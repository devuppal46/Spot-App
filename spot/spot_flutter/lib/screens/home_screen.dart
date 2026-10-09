import 'package:flutter/material.dart';
import 'package:spot_client/spot_client.dart';

import '../client.dart';
import '../theme.dart';
import '../util/events_changed.dart';
import '../util/format.dart';
import '../util/location.dart';
import '../widgets/category.dart';
import '../widgets/event_card.dart';
import '../widgets/events_map.dart';
import '../widgets/states.dart';
import 'event_detail_screen.dart';

/// Radius of the nearby feed. Large enough to cover most of Delhi from CP.
const feedRadiusKm = 20.0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  BrowseLocation? _location;
  EventCategory? _category;
  List<EventView>? _events;
  String? _error;
  bool _loading = false;
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    eventsChanged.addListener(refresh);
    _load(resolveLocation: true);
  }

  @override
  void dispose() {
    eventsChanged.removeListener(refresh);
    super.dispose();
  }

  /// Reloads the feed. Called after joining, posting, etc.
  Future<void> refresh() => _load();

  Future<void> _load({bool resolveLocation = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (resolveLocation || _location == null) {
        final location = await resolveBrowseLocation();
        if (!mounted) return;
        setState(() => _location = location);
      }
      final loc = _location!;
      final events = await client.event.getNearbyEvents(
        loc.lat,
        loc.lng,
        feedRadiusKm,
        category: _category,
      );
      if (!mounted) return;
      setState(() => _events = events);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = friendlyError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Changes made on the detail screen arrive through [eventsChanged].
  Future<void> _open(EventView view) =>
      openEvent(context, view.event.id!, initial: view);

  void _selectCategory(EventCategory? category) {
    if (category == _category) return;
    setState(() {
      _category = category;
      _events = null;
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.md, Gap.md, Gap.md, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Nearby', style: text.headlineMedium),
                      ),
                      SegmentedButton<bool>(
                        showSelectedIcon: false,
                        style: const ButtonStyle(
                          visualDensity: VisualDensity.compact,
                        ),
                        segments: const [
                          ButtonSegment(
                            value: false,
                            icon: Icon(Icons.view_agenda_outlined),
                            tooltip: 'List',
                          ),
                          ButtonSegment(
                            value: true,
                            icon: Icon(Icons.map_outlined),
                            tooltip: 'Map',
                          ),
                        ],
                        selected: {_showMap},
                        onSelectionChanged: (s) =>
                            setState(() => _showMap = s.first),
                      ),
                    ],
                  ),
                  const SizedBox(height: Gap.xs),
                  Text(
                    "Find what's happening around you, in person.",
                    style: text.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (_location?.isFallback ?? false)
              _BrowsingDelhiBanner(
                reason: _location!.reason,
                onRetry: () => _load(resolveLocation: true),
              ),
            const SizedBox(height: Gap.sm + 4),
            CategoryFilterBar(selected: _category, onChanged: _selectCategory),
            const SizedBox(height: Gap.xs),
            Expanded(
              child: _showMap && _events != null && _location != null
                  ? EventsMap(
                      events: _events!,
                      centerLat: _location!.lat,
                      centerLng: _location!.lng,
                      onOpen: _open,
                    )
                  : RefreshIndicator(
                      onRefresh: () => _load(resolveLocation: true),
                      child: _buildBody(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    final events = _events;
    if (events == null && _error == null) return const LoadingCards();

    if (_error != null && (events == null || events.isEmpty)) {
      return _scrollable(
        MessageState(
          icon: Icons.wifi_off_rounded,
          title: "Couldn't load events",
          message: _error,
          actionLabel: 'Try again',
          onAction: _loading ? null : _load,
        ),
      );
    }

    if (events!.isEmpty) {
      return _scrollable(
        MessageState(
          icon: Icons.event_busy_outlined,
          title: _category == null
              ? 'Nothing nearby yet'
              : 'No ${_category!.label.toLowerCase()} events nearby',
          message: 'Be the first — post an event and invite people around you.',
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(Gap.md, Gap.sm, Gap.md, Gap.xl),
      itemCount: events.length,
      separatorBuilder: (_, _) => const SizedBox(height: Gap.md),
      itemBuilder: (context, i) => EventCard(
        view: events[i],
        onTap: () => _open(events[i]),
      ),
    );
  }

  /// Keeps pull-to-refresh working on empty and error states.
  Widget _scrollable(Widget child) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: child,
      ),
    ),
  );
}

class _BrowsingDelhiBanner extends StatelessWidget {
  final String? reason;
  final VoidCallback onRetry;
  const _BrowsingDelhiBanner({required this.reason, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(Gap.md, Gap.md, Gap.md, 0),
      padding: const EdgeInsets.fromLTRB(Gap.md, Gap.sm, Gap.xs, Gap.sm),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.location_city_rounded, color: colors.primary, size: 20),
          const SizedBox(width: Gap.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Browsing Delhi',
                  style: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  [
                    ?reason,
                    'showing events around Connaught Place',
                  ].join(' — '),
                  style: text.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
