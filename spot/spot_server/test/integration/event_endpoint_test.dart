import 'package:spot_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _hostId = '0190a000-0000-7000-8000-000000000001';

// Connaught Place, Hauz Khas (~9 km away) and Noida (~20 km away).
const _cp = (lat: 28.6315, lng: 77.2167);
const _hauzKhas = (lat: 28.5494, lng: 77.2001);
const _noida = (lat: 28.5355, lng: 77.3910);

void main() {
  withServerpod('Given the event endpoint', (sessionBuilder, endpoints) {
    final host = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(_hostId, {}),
    );

    Future<EventView> create({
      String title = 'Sunday debate',
      EventCategory category = EventCategory.debate,
      Duration startsIn = const Duration(days: 1),
      ({double lat, double lng}) at = _cp,
      int capacity = 10,
    }) => endpoints.event.createEvent(
      host,
      title: title,
      description: 'Bring your opinions.',
      category: category,
      startsAt: DateTime.now().add(startsIn),
      lat: at.lat,
      lng: at.lng,
      locationName: 'Central Park, CP',
      capacity: capacity,
    );

    test('when unauthenticated then calls are rejected', () async {
      await expectLater(
        endpoints.event.getNearbyEvents(
          sessionBuilder.copyWith(
            authentication: AuthenticationOverride.unauthenticated(),
          ),
          _cp.lat,
          _cp.lng,
          10,
        ),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test('when creating an event then it is stored as open', () async {
      final view = await create();
      expect(view.event.id, isNotNull);
      expect(view.event.status, EventStatus.open);
      expect(view.event.hostId.toString(), _hostId);
    });

    test('when capacity is below 2 then creating fails', () async {
      await expectLater(
        create(capacity: 1),
        throwsA(isA<SpotException>()),
      );
    });

    test('when start time is in the past then creating fails', () async {
      await expectLater(
        create(startsIn: const Duration(hours: -1)),
        throwsA(isA<SpotException>()),
      );
    });

    test(
      'when searching nearby then only events in radius return, soonest first',
      () async {
        await create(title: 'Later', startsIn: const Duration(days: 3));
        await create(title: 'Sooner', at: _hauzKhas);
        await create(title: 'Far away', at: _noida);

        final nearby = await endpoints.event.getNearbyEvents(
          host,
          _cp.lat,
          _cp.lng,
          10,
        );

        expect(nearby.map((v) => v.event.title), ['Sooner', 'Later']);
        expect(nearby.first.distanceKm, closeTo(9.2, 0.5));
        expect(nearby.last.distanceKm, closeTo(0, 0.01));
      },
    );

    test(
      'when filtering by category then other categories are hidden',
      () async {
        await create(title: 'Debate');
        await create(title: 'Diwali mela', category: EventCategory.festive);

        final festive = await endpoints.event.getNearbyEvents(
          host,
          _cp.lat,
          _cp.lng,
          10,
          category: EventCategory.festive,
        );

        expect(festive.map((v) => v.event.title), ['Diwali mela']);
      },
    );

    test('when getting an unknown event then it throws', () async {
      await expectLater(
        endpoints.event.getEvent(host, 999999),
        throwsA(isA<SpotException>()),
      );
    });
  });
}
