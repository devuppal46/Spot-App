import 'package:flutter/material.dart';
import 'package:spot_client/spot_client.dart';

import '../client.dart';
import '../theme.dart';
import '../util/events_changed.dart';
import '../util/format.dart';
import '../widgets/event_card.dart';
import '../widgets/states.dart';
import 'event_detail_screen.dart';
import 'manage_event_screen.dart';

/// Events the user hosts and has joined, in two tabs.
class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  MyEvents? _events;
  String? _error;

  @override
  void initState() {
    super.initState();
    eventsChanged.addListener(_load);
    _load();
  }

  @override
  void dispose() {
    eventsChanged.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final events = await client.event.getMyEvents();
      if (mounted) {
        setState(() {
          _events = events;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = _events;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My events'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Hosting${_count(events?.hosting)}'),
              Tab(text: 'Joined${_count(events?.joined)}'),
            ],
          ),
        ),
        body: events == null
            ? (_error == null
                  ? const LoadingCards()
                  : MessageState(
                      icon: Icons.wifi_off_rounded,
                      title: "Couldn't load your events",
                      message: _error,
                      actionLabel: 'Try again',
                      onAction: _load,
                    ))
            : TabBarView(
                children: [
                  _EventList(
                    events: events.hosting,
                    onRefresh: _load,
                    onTap: _openHosted,
                    empty: const MessageState(
                      icon: Icons.add_location_alt_outlined,
                      title: "You're not hosting anything yet",
                      message:
                          'Use the Post tab to host a debate, a reading or a '
                          'game night.',
                    ),
                  ),
                  _EventList(
                    events: events.joined,
                    onRefresh: _load,
                    onTap: (v) => openEvent(context, v.event.id!, initial: v),
                    empty: const MessageState(
                      icon: Icons.explore_outlined,
                      title: 'No plans yet',
                      message: 'Events you join from Home will show up here.',
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String _count(List<EventView>? list) =>
      list == null || list.isEmpty ? '' : ' (${list.length})';

  void _openHosted(EventView view) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ManageEventScreen(view: view)),
    );
  }
}

class _EventList extends StatelessWidget {
  final List<EventView> events;
  final Future<void> Function() onRefresh;
  final void Function(EventView) onTap;
  final Widget empty;

  const _EventList({
    required this.events,
    required this.onRefresh,
    required this.onTap,
    required this.empty,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: events.isEmpty
          ? LayoutBuilder(
              builder: (context, c) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: c.maxHeight),
                  child: empty,
                ),
              ),
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Gap.md),
              itemCount: events.length,
              separatorBuilder: (_, _) => const SizedBox(height: Gap.md),
              itemBuilder: (context, i) {
                final v = events[i];
                final isPast = !v.event.startsAt.isAfter(DateTime.now());
                return Opacity(
                  opacity: isPast ? 0.6 : 1,
                  child: EventCard(view: v, onTap: () => onTap(v)),
                );
              },
            ),
    );
  }
}
