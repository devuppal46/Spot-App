import 'package:spot_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _cp = (lat: 28.6315, lng: 77.2167);

String _uuid(int n) =>
    '0190a000-0000-7000-8000-${n.toString().padLeft(12, '0')}';

void main() {
  withServerpod('Given an event with capacity 2', (sessionBuilder, endpoints) {
    TestSessionBuilder as(int n) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(_uuid(n), {}),
    );
    final host = as(0);
    late int eventId;

    setUp(() async {
      final view = await endpoints.event.createEvent(
        host,
        title: 'Board games night',
        description: 'Catan and chai.',
        category: EventCategory.games,
        startsAt: DateTime.now().add(const Duration(days: 2)),
        lat: _cp.lat,
        lng: _cp.lng,
        locationName: 'Café, Connaught Place',
        capacity: 2,
      );
      eventId = view.event.id!;
    });

    test('when a user joins then counts and joinedByMe update', () async {
      final view = await endpoints.event.joinEvent(as(1), eventId);
      expect(view.attendeeCount, 1);
      expect(view.spotsLeft, 1);
      expect(view.joinedByMe, isTrue);
      expect(view.hostedByMe, isFalse);

      final hostView = await endpoints.event.getEvent(host, eventId);
      expect(hostView.joinedByMe, isFalse);
      expect(hostView.hostedByMe, isTrue);
    });

    test('when a user joins twice then the second join fails', () async {
      await endpoints.event.joinEvent(as(1), eventId);
      await expectLater(
        endpoints.event.joinEvent(as(1), eventId),
        throwsA(
          isA<SpotException>().having(
            (e) => e.message,
            'message',
            contains('already'),
          ),
        ),
      );
    });

    test('when the event is full then a third user cannot join', () async {
      await endpoints.event.joinEvent(as(1), eventId);
      await endpoints.event.joinEvent(as(2), eventId);
      await expectLater(
        endpoints.event.joinEvent(as(3), eventId),
        throwsA(
          isA<SpotException>().having(
            (e) => e.message,
            'message',
            contains('full'),
          ),
        ),
      );
    });

    test('when a user leaves then their spot frees up', () async {
      await endpoints.event.joinEvent(as(1), eventId);
      await endpoints.event.joinEvent(as(2), eventId);
      final view = await endpoints.event.leaveEvent(as(1), eventId);
      expect(view.spotsLeft, 1);
      expect(view.joinedByMe, isFalse);
      await endpoints.event.joinEvent(as(3), eventId);
    });

    test('when leaving an event not joined then it fails', () async {
      await expectLater(
        endpoints.event.leaveEvent(as(1), eventId),
        throwsA(isA<SpotException>()),
      );
    });

    test('when the host tries to join then it fails', () async {
      await expectLater(
        endpoints.event.joinEvent(host, eventId),
        throwsA(isA<SpotException>()),
      );
    });

    test('when a non-host cancels then it fails', () async {
      await expectLater(
        endpoints.event.cancelEvent(as(1), eventId),
        throwsA(isA<SpotException>()),
      );
    });

    test(
      'when the host cancels then nobody can join and it leaves the feed',
      () async {
        final view = await endpoints.event.cancelEvent(host, eventId);
        expect(view.event.status, EventStatus.cancelled);

        await expectLater(
          endpoints.event.joinEvent(as(1), eventId),
          throwsA(
            isA<SpotException>().having(
              (e) => e.message,
              'message',
              contains('cancelled'),
            ),
          ),
        );
        final feed = await endpoints.event.getNearbyEvents(
          as(1),
          _cp.lat,
          _cp.lng,
          10,
        );
        expect(feed.map((v) => v.event.id), isNot(contains(eventId)));
      },
    );

    test('when a non-host asks for attendees then it fails', () async {
      await expectLater(
        endpoints.event.getAttendees(as(1), eventId),
        throwsA(isA<SpotException>()),
      );
    });

    test('when the host asks for attendees then they are listed', () async {
      await endpoints.event.joinEvent(as(1), eventId);
      final attendees = await endpoints.event.getAttendees(host, eventId);
      expect(attendees.map((a) => a.userId.toString()), [_uuid(1)]);
    });

    test('when getting my events then hosting and joined are split', () async {
      await endpoints.event.joinEvent(as(1), eventId);

      final hostEvents = await endpoints.event.getMyEvents(host);
      expect(hostEvents.hosting.map((v) => v.event.id), [eventId]);
      expect(hostEvents.joined, isEmpty);

      final guestEvents = await endpoints.event.getMyEvents(as(1));
      expect(guestEvents.hosting, isEmpty);
      expect(guestEvents.joined.map((v) => v.event.id), [eventId]);
    });
  });

  withServerpod(
    'Given an event with capacity 3 and 10 users joining at once',
    (sessionBuilder, endpoints) {
      TestSessionBuilder as(int n) => sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          _uuid(n),
          {},
        ),
      );

      test(
        'then exactly 3 joins succeed and capacity is never exceeded',
        () async {
          final view = await endpoints.event.createEvent(
            as(0),
            title: 'Poetry open mic',
            description: 'Hindi, Urdu, English.',
            category: EventCategory.other,
            startsAt: DateTime.now().add(const Duration(days: 1)),
            lat: _cp.lat,
            lng: _cp.lng,
            locationName: 'Khan Market',
            capacity: 3,
          );
          final id = view.event.id!;

          final results = await Future.wait([
            for (var n = 1; n <= 10; n++)
              endpoints.event
                  .joinEvent(as(n), id)
                  .then((_) => true)
                  .catchError((_) => false, test: (e) => e is SpotException),
          ]);

          expect(results.where((ok) => ok), hasLength(3));
          final after = await endpoints.event.getEvent(as(0), id);
          expect(after.attendeeCount, 3);
          expect(after.spotsLeft, 0);
        },
      );
    },
    // The endpoint opens its own transactions concurrently.
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
