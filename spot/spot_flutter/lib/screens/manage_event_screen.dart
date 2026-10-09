import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spot_client/spot_client.dart';

import '../client.dart';
import '../theme.dart';
import '../util/events_changed.dart';
import '../util/format.dart';
import '../widgets/states.dart';

/// Host-only: see who's coming and cancel the event.
class ManageEventScreen extends StatefulWidget {
  final EventView view;
  const ManageEventScreen({super.key, required this.view});

  @override
  State<ManageEventScreen> createState() => _ManageEventScreenState();
}

class _ManageEventScreenState extends State<ManageEventScreen> {
  late EventView _view = widget.view;
  List<AttendeeInfo>? _attendees;
  String? _error;
  bool _cancelling = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final id = _view.event.id!;
      final results = await Future.wait([
        client.event.getEvent(id),
        client.event.getAttendees(id),
      ]);
      if (!mounted) return;
      setState(() {
        _view = results[0] as EventView;
        _attendees = results[1] as List<AttendeeInfo>;
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    }
  }

  Future<void> _cancel() async {
    final going = _view.attendeeCount;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel this event?'),
        content: Text(
          going == 0
              ? "It will be removed from the feed. This can't be undone."
              : '$going ${going == 1 ? 'person has' : 'people have'} joined. '
                    "They'll see it as cancelled. This can't be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep event'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              minimumSize: const Size(0, 44),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancel event'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _cancelling = true);
    try {
      final view = await client.event.cancelEvent(_view.event.id!);
      if (!mounted) return;
      setState(() => _view = view);
      notifyEventsChanged();
      showInfoSnackBar(context, 'Event cancelled.');
    } catch (e) {
      if (mounted) showErrorSnackBar(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _cancelling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = _view.event;
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final isCancelled = e.status == EventStatus.cancelled;
    final isPast = !e.startsAt.isAfter(DateTime.now().toUtc());
    final attendees = _attendees;

    return Scaffold(
      appBar: AppBar(title: const Text('Manage event')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(Gap.md),
          children: [
            Text(e.title, style: text.headlineSmall),
            const SizedBox(height: Gap.xs),
            Text(
              '${formatWhenLong(e.startsAt)}\n${e.locationName}',
              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: Gap.md),
            Row(
              children: [
                _Stat(label: 'Going', value: '${_view.attendeeCount}'),
                const SizedBox(width: Gap.sm + 4),
                _Stat(label: 'Spots left', value: '${_view.spotsLeft}'),
                const SizedBox(width: Gap.sm + 4),
                _Stat(label: 'Capacity', value: '${e.capacity}'),
              ],
            ),
            const SizedBox(height: Gap.lg),
            Text('Attendees', style: text.titleMedium),
            const SizedBox(height: Gap.sm),
            if (_error != null && attendees == null)
              MessageState(
                icon: Icons.error_outline,
                title: "Couldn't load attendees",
                message: _error,
                actionLabel: 'Try again',
                onAction: _load,
              )
            else if (attendees == null)
              const Padding(
                padding: EdgeInsets.all(Gap.lg),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (attendees.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(Gap.md),
                  child: Text(
                    'No one has joined yet. Share the event with friends!',
                    style: text.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              Card(
                child: Column(
                  children: [
                    for (final (i, a) in attendees.indexed) ...[
                      if (i > 0) const Divider(height: 1, indent: 72),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colors.primary.withValues(
                            alpha: 0.12,
                          ),
                          child: Text(
                            a.name.isEmpty ? '?' : a.name[0].toUpperCase(),
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        title: Text(a.name),
                        subtitle: Text(
                          'Joined ${DateFormat('d MMM, h:mm a').format(a.joinedAt.toLocal())}',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: Gap.xl),
            if (isCancelled)
              Center(
                child: Text(
                  'This event has been cancelled.',
                  style: text.bodyMedium?.copyWith(color: colors.error),
                ),
              )
            else if (!isPast)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.error,
                  side: BorderSide(color: colors.error.withValues(alpha: 0.5)),
                ),
                onPressed: _cancelling ? null : _cancel,
                icon: const Icon(Icons.event_busy),
                label: Text(_cancelling ? 'Cancelling…' : 'Cancel event'),
              ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Gap.sm + 4,
            horizontal: Gap.sm,
          ),
          child: Column(
            children: [
              Text(value, style: text.headlineSmall),
              Text(label, style: text.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}
