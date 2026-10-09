import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spot_client/spot_client.dart';

import '../client.dart';
import '../theme.dart';
import '../util/events_changed.dart';
import '../util/format.dart';
import '../widgets/category.dart';
import '../widgets/states.dart';
import 'manage_event_screen.dart';

/// Opens the detail screen for [eventId]. Completes with true when the user
/// changed something (joined, left, cancelled), so lists can refresh.
Future<bool> openEvent(
  BuildContext context,
  int eventId, {
  EventView? initial,
}) async {
  final changed = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => EventDetailScreen(eventId: eventId, initial: initial),
    ),
  );
  return changed ?? false;
}

class EventDetailScreen extends StatefulWidget {
  final int eventId;

  /// Shown immediately while the fresh copy loads.
  final EventView? initial;

  const EventDetailScreen({super.key, required this.eventId, this.initial});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  EventView? _view;
  String? _loadError;
  bool _busy = false;
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _view = widget.initial;
    _load();
  }

  Future<void> _load() async {
    try {
      final view = await client.event.getEvent(widget.eventId);
      if (!mounted) return;
      setState(() {
        // Keep the distance from the list; the detail call has no location.
        _view = view.copyWith(distanceKm: _view?.distanceKm);
        _loadError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadError = friendlyError(e));
    }
  }

  Future<void> _run(Future<EventView> Function() action, String done) async {
    setState(() => _busy = true);
    try {
      final view = await action();
      if (!mounted) return;
      setState(() {
        _view = view.copyWith(distanceKm: _view?.distanceKm);
        _changed = true;
      });
      notifyEventsChanged();
      showInfoSnackBar(context, done);
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, friendlyError(e));
      // The event may have filled up or been cancelled meanwhile.
      await _load();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _join() => _run(
    () => client.event.joinEvent(widget.eventId),
    "You're in! See you there.",
  );

  Future<void> _manage(EventView view) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ManageEventScreen(view: view)),
    );
    // The host may have cancelled it.
    await _load();
  }

  void _leave() => _run(
    () => client.event.leaveEvent(widget.eventId),
    'You left the event.',
  );

  @override
  Widget build(BuildContext context) {
    final view = _view;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop(_changed);
      },
      child: Scaffold(
        appBar: AppBar(),
        body: view == null
            ? (_loadError == null
                  ? const Center(child: CircularProgressIndicator())
                  : MessageState(
                      icon: Icons.error_outline,
                      title: "Couldn't load this event",
                      message: _loadError,
                      actionLabel: 'Try again',
                      onAction: _load,
                    ))
            : RefreshIndicator(onRefresh: _load, child: _content(view)),
        bottomNavigationBar: view == null ? null : _actionBar(view),
      ),
    );
  }

  Widget _content(EventView view) {
    final e = view.event;
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final isCancelled = e.status == EventStatus.cancelled;

    return ListView(
      padding: const EdgeInsets.fromLTRB(Gap.md, 0, Gap.md, Gap.xl),
      children: [
        Row(children: [CategoryTag(e.category)]),
        const SizedBox(height: Gap.sm + 4),
        Text(e.title, style: text.headlineMedium?.copyWith(height: 1.15)),
        if (isCancelled) ...[
          const SizedBox(height: Gap.sm + 4),
          _Banner(
            icon: Icons.event_busy,
            text: 'This event has been cancelled by the host.',
            color: colors.error,
          ),
        ],
        const SizedBox(height: Gap.md),
        _InfoRow(
          icon: Icons.schedule,
          title: formatWhenLong(e.startsAt),
        ),
        _InfoRow(
          icon: Icons.place_outlined,
          title: e.locationName,
          subtitle: view.distanceKm == null
              ? null
              : '${formatDistance(view.distanceKm)} away',
        ),
        _InfoRow(
          icon: Icons.person_outline,
          title: view.hostedByMe ? 'Hosted by you' : 'Hosted by ${e.hostName}',
        ),
        _InfoRow(
          icon: Icons.groups_outlined,
          title: '${view.attendeeCount} going · ${spotsLeftLabel(view)}',
          subtitle: 'Capacity ${e.capacity}',
        ),
        const SizedBox(height: Gap.md),
        _MapPreview(lat: e.lat, lng: e.lng, title: e.locationName),
        if (e.description.isNotEmpty) ...[
          const SizedBox(height: Gap.lg),
          Text('About', style: text.titleMedium),
          const SizedBox(height: Gap.sm),
          Text(e.description, style: text.bodyLarge?.copyWith(height: 1.5)),
        ],
      ],
    );
  }

  Widget _actionBar(EventView view) {
    final e = view.event;
    final isCancelled = e.status == EventStatus.cancelled;
    final isPast = !e.startsAt.isAfter(DateTime.now().toUtc());

    final Widget button;
    if (view.hostedByMe) {
      button = FilledButton.tonalIcon(
        onPressed: () => _manage(view),
        icon: const Icon(Icons.tune),
        label: Text(
          isCancelled ? 'Cancelled — view attendees' : 'Manage event',
        ),
      );
    } else if (isCancelled) {
      button = const FilledButton(onPressed: null, child: Text('Cancelled'));
    } else if (isPast) {
      button = const FilledButton(
        onPressed: null,
        child: Text('This event has started'),
      );
    } else if (view.joinedByMe) {
      button = OutlinedButton(
        onPressed: _busy ? null : _leave,
        child: _busy ? const _Spinner() : const Text('Leave event'),
      );
    } else if (view.spotsLeft == 0) {
      button = const FilledButton(onPressed: null, child: Text('Event full'));
    } else {
      button = FilledButton(
        onPressed: _busy ? null : _join,
        child: _busy ? const _Spinner(onPrimary: true) : const Text('Join'),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.md, Gap.sm, Gap.md, Gap.md),
        child: SizedBox(width: double.infinity, child: button),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  const _InfoRow({required this.icon, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Gap.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: colors.primary),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.bodyLarge),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: text.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  final double lat;
  final double lng;
  final String title;
  const _MapPreview({
    required this.lat,
    required this.lng,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final position = LatLng(lat, lng);
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 180,
        child: GoogleMap(
          // Lite mode renders a static bitmap: cheap, and right for a preview.
          liteModeEnabled: true,
          initialCameraPosition: CameraPosition(target: position, zoom: 15),
          markers: {
            Marker(
              markerId: const MarkerId('event'),
              position: position,
              infoWindow: InfoWindow(title: title),
            ),
          },
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _Banner({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Gap.sm + 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: Gap.sm),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Spinner extends StatelessWidget {
  final bool onPrimary;
  const _Spinner({this.onPrimary = false});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(
      strokeWidth: 2.4,
      color: onPrimary ? Theme.of(context).colorScheme.onPrimary : null,
    ),
  );
}
