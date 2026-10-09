import 'package:spot_server/src/generated/protocol.dart';
import 'package:spot_server/src/seed/seed_events.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given an empty database', (sessionBuilder, endpoints) {
    final session = sessionBuilder.build();

    test('when seeding then 12 upcoming events are inserted', () async {
      expect(await seedEvents(session), 12);

      final events = await Event.db.find(session);
      expect(events, hasLength(12));
      final now = DateTime.now().toUtc();
      expect(events.every((e) => e.startsAt.isAfter(now)), isTrue);
      expect(
        events.every(
          (e) => e.startsAt.isBefore(now.add(const Duration(days: 15))),
        ),
        isTrue,
      );
      expect(
        events.map((e) => e.category).toSet(),
        EventCategory.values.toSet(),
      );
    });

    test('when seeding twice then no duplicates are created', () async {
      await seedEvents(session);
      expect(await seedEvents(session), 0);
      expect(await Event.db.count(session), 12);
    });

    test(
      'when browsing from Connaught Place then all seeded events are within 20 km',
      () async {
        await seedEvents(session);
        final feed = await endpoints.event.getNearbyEvents(
          sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              '0190a000-0000-7000-8000-000000000099',
              {},
            ),
          ),
          28.6315,
          77.2167,
          20,
        );
        expect(feed, hasLength(12));
      },
    );
  });
}
