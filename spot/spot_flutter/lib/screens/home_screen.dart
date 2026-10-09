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
    final header = _Header(
      showMap: _showMap,
      onToggle: (v) => setState(() => _showMap = v),
    );
    final banner = (_location?.isFallback ?? false)
        ? _BrowsingDelhiBanner(
            reason: _location!.reason,
            onRetry: () => _load(resolveLocation: true),
          )
        : null;
    final filters = CategoryFilterBar(
      selected: _category,
      onChanged: _selectCategory,
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: _showMap
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  header,
                  ?banner,
                  const SizedBox(height: Gap.sm + 4),
                  filters,
                  const SizedBox(height: Gap.sm),
                  Expanded(child: _buildMap()),
                ],
              )
            // In the list, the header scrolls away and the filters stay
            // pinned, so small screens keep room for the events.
            : RefreshIndicator(
                onRefresh: () => _load(resolveLocation: true),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: header),
                    if (banner != null) SliverToBoxAdapter(child: banner),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _PinnedFilters(filters),
                    ),
                    ..._buildListSlivers(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildMap() {
    final events = _events, location = _location;
    if (events == null || location == null) {
      return _error != null
          ? MessageState(
              icon: Icons.wifi_off_rounded,
              title: "Couldn't load events",
              message: _error,
              actionLabel: 'Try again',
              onAction: _loading ? null : _load,
            )
          : const Center(child: CircularProgressIndicator());
    }
    return EventsMap(
      events: events,
      centerLat: location.lat,
      centerLng: location.lng,
      onOpen: _open,
    );
  }

  List<Widget> _buildListSlivers() {
    const padding = EdgeInsets.fromLTRB(Gap.md, Gap.sm, Gap.md, Gap.xl);
    final events = _events;

    if (events == null && _error == null) {
      return [
        SliverPadding(
          padding: padding,
          sliver: SliverList.separated(
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(height: Gap.md),
            itemBuilder: (_, _) => const SkeletonCard(),
          ),
        ),
      ];
    }

    if (_error != null && (events == null || events.isEmpty)) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: MessageState(
            icon: Icons.wifi_off_rounded,
            title: "Couldn't load events",
            message: _error,
            actionLabel: 'Try again',
            onAction: _loading ? null : _load,
          ),
        ),
      ];
    }

    if (events!.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: MessageState(
            icon: Icons.event_busy_outlined,
            title: _category == null
                ? 'Nothing nearby yet'
                : 'No ${_category!.label.toLowerCase()} events nearby',
            message:
                'Be the first — post an event and invite people around you.',
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: padding,
        sliver: SliverList.separated(
          itemCount: events.length,
          separatorBuilder: (_, _) => const SizedBox(height: Gap.md),
          itemBuilder: (context, i) =>
              EventCard(view: events[i], onTap: () => _open(events[i])),
        ),
      ),
    ];
  }
}

class _Header extends StatelessWidget {
  final bool showMap;
  final ValueChanged<bool> onToggle;
  const _Header({required this.showMap, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.md, Gap.md, Gap.md, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Nearby', style: text.headlineMedium)),
              SegmentedButton<bool>(
                showSelectedIcon: false,
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
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
                selected: {showMap},
                onSelectionChanged: (s) => onToggle(s.first),
              ),
            ],
          ),
          const SizedBox(height: Gap.xs),
          Text(
            "Find what's happening around you, in person.",
            style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Keeps the category chips stuck to the top while the list scrolls.
class _PinnedFilters extends SliverPersistentHeaderDelegate {
  final Widget child;
  _PinnedFilters(this.child);

  static const _height = 44.0 + Gap.sm * 2;

  @override
  double get minExtent => _height;
  @override
  double get maxExtent => _height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: Gap.sm),
      child: child,
    );
  }

  @override
  bool shouldRebuild(_PinnedFilters old) => old.child != child;
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
      margin: const EdgeInsets.fromLTRB(Gap.md, Gap.sm + 4, Gap.md, 0),
      padding: const EdgeInsets.fromLTRB(Gap.sm + 4, Gap.xs, Gap.xs, Gap.xs),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.location_city_rounded, color: colors.primary, size: 18),
          const SizedBox(width: Gap.sm),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Browsing Delhi',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: ' · ${reason ?? 'Showing'} — near Connaught Place',
                  ),
                ],
              ),
              style: text.bodySmall?.copyWith(color: colors.onSurface),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            tooltip: 'Use my location',
            onPressed: onRetry,
            icon: Icon(Icons.my_location, size: 20, color: colors.primary),
          ),
        ],
      ),
    );
  }
}
