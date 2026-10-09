import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spot_client/spot_client.dart';

import '../theme.dart';
import 'event_card.dart';

/// Nearby events as pins. Tapping a pin shows a card; tapping the card
/// calls [onOpen].
class EventsMap extends StatefulWidget {
  final List<EventView> events;
  final double centerLat;
  final double centerLng;
  final void Function(EventView) onOpen;

  const EventsMap({
    super.key,
    required this.events,
    required this.centerLat,
    required this.centerLng,
    required this.onOpen,
  });

  @override
  State<EventsMap> createState() => _EventsMapState();
}

class _EventsMapState extends State<EventsMap> {
  int? _selectedId;

  @override
  void didUpdateWidget(EventsMap old) {
    super.didUpdateWidget(old);
    // Drop the selection if a filter change removed the event.
    if (_selectedId != null &&
        !widget.events.any((v) => v.event.id == _selectedId)) {
      _selectedId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.events
        .where((v) => v.event.id == _selectedId)
        .firstOrNull;

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.centerLat, widget.centerLng),
            zoom: 11.5,
          ),
          markers: {
            for (final v in widget.events)
              Marker(
                markerId: MarkerId('${v.event.id}'),
                position: LatLng(v.event.lat, v.event.lng),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  v.event.id == _selectedId
                      ? BitmapDescriptor.hueOrange
                      : BitmapDescriptor.hueRed,
                ),
                // We show our own card instead of the default info window.
                consumeTapEvents: true,
                onTap: () => setState(() => _selectedId = v.event.id),
              ),
          },
          onTap: (_) => setState(() => _selectedId = null),
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
        if (widget.events.isEmpty)
          Positioned(
            top: Gap.md,
            left: Gap.md,
            right: Gap.md,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surface,
              child: const Padding(
                padding: EdgeInsets.all(Gap.sm + 4),
                child: Text(
                  'No events match here yet.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        if (selected != null)
          Positioned(
            left: Gap.md,
            right: Gap.md,
            bottom: Gap.md,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(18),
              color: Colors.transparent,
              child: EventCard(
                view: selected,
                onTap: () => widget.onOpen(selected),
              ),
            ),
          ),
      ],
    );
  }
}
