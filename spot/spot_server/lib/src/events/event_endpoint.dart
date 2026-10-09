import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'geo.dart';

/// Creating, finding, joining and managing events.
///
/// All methods require a signed-in user. Join and capacity rules are enforced
/// here, never in the app.
class EventEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const maxRadiusKm = 50.0;
  static const minCapacity = 2;
  static const maxCapacity = 500;

  Future<EventView> createEvent(
    Session session, {
    required String title,
    required String description,
    required EventCategory category,
    required DateTime startsAt,
    required double lat,
    required double lng,
    required String locationName,
    required int capacity,
  }) async {
    final hostId = _userId(session);

    title = title.trim();
    description = description.trim();
    locationName = locationName.trim();
    if (title.isEmpty || title.length > 80) {
      throw SpotException(message: 'Title must be 1–80 characters.');
    }
    if (description.length > 2000) {
      throw SpotException(message: 'Description is too long.');
    }
    if (locationName.isEmpty || locationName.length > 120) {
      throw SpotException(message: 'Add a place name (up to 120 characters).');
    }
    if (capacity < minCapacity || capacity > maxCapacity) {
      throw SpotException(
        message: 'Capacity must be between $minCapacity and $maxCapacity.',
      );
    }
    if (!startsAt.toUtc().isAfter(DateTime.now().toUtc())) {
      throw SpotException(message: 'The event must start in the future.');
    }
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
      throw SpotException(message: 'Invalid location.');
    }

    final event = await Event.db.insertRow(
      session,
      Event(
        title: title,
        description: description,
        category: category,
        startsAt: startsAt.toUtc(),
        lat: lat,
        lng: lng,
        locationName: locationName,
        capacity: capacity,
        hostId: hostId,
        hostName: await _displayName(session, hostId),
      ),
    );
    return (await _views(session, [event], hostId)).single;
  }

  /// Upcoming open events within [radiusKm] of ([lat], [lng]), soonest first.
  Future<List<EventView>> getNearbyEvents(
    Session session,
    double lat,
    double lng,
    double radiusKm, {
    EventCategory? category,
  }) async {
    final userId = _userId(session);
    radiusKm = radiusKm.clamp(0.5, maxRadiusKm);
    final box = boundingBox(lat, lng, radiusKm);
    final now = DateTime.now().toUtc();

    final candidates = await Event.db.find(
      session,
      where: (t) {
        var w =
            t.status.equals(EventStatus.open) &
            (t.startsAt > now) &
            t.lat.between(box.minLat, box.maxLat) &
            t.lng.between(box.minLng, box.maxLng);
        if (category != null) w = w & t.category.equals(category);
        return w;
      },
      orderBy: (t) => t.startsAt,
      limit: 200,
    );

    final inRadius = [
      for (final e in candidates)
        if (haversineKm(lat, lng, e.lat, e.lng) <= radiusKm) e,
    ];
    return _views(session, inRadius, userId, lat: lat, lng: lng);
  }

  Future<EventView> getEvent(
    Session session,
    int id, {
    double? lat,
    double? lng,
  }) async {
    final userId = _userId(session);
    final event = await _findEvent(session, id);
    return (await _views(session, [event], userId, lat: lat, lng: lng)).single;
  }

  /// Takes a spot at the event. Fails if the event is full, cancelled,
  /// already started, hosted by the caller, or already joined.
  Future<EventView> joinEvent(Session session, int eventId) async {
    final userId = _userId(session);

    await session.db.transaction((tx) async {
      // Lock the event row so concurrent joins are serialised and the
      // capacity check below cannot be raced.
      final event = await Event.db.findById(
        session,
        eventId,
        transaction: tx,
        lockMode: LockMode.forUpdate,
      );
      if (event == null) throw SpotException(message: 'Event not found.');
      if (event.status == EventStatus.cancelled) {
        throw SpotException(message: 'This event has been cancelled.');
      }
      if (!event.startsAt.isAfter(DateTime.now().toUtc())) {
        throw SpotException(message: 'This event has already started.');
      }
      if (event.hostId == userId) {
        throw SpotException(message: "You're hosting this event.");
      }

      final existing = await Attendance.db.findFirstRow(
        session,
        where: (t) => t.eventId.equals(eventId) & t.userId.equals(userId),
        transaction: tx,
      );
      if (existing != null) {
        throw SpotException(message: "You've already joined this event.");
      }

      final count = await Attendance.db.count(
        session,
        where: (t) => t.eventId.equals(eventId),
        transaction: tx,
      );
      if (count >= event.capacity) {
        throw SpotException(message: 'Sorry, this event is full.');
      }

      await Attendance.db.insertRow(
        session,
        Attendance(eventId: eventId, userId: userId),
        transaction: tx,
      );
    });

    return getEvent(session, eventId);
  }

  /// Gives up the caller's spot. Not allowed once the event has started.
  Future<EventView> leaveEvent(Session session, int eventId) async {
    final userId = _userId(session);
    final event = await _findEvent(session, eventId);
    if (!event.startsAt.isAfter(DateTime.now().toUtc())) {
      throw SpotException(message: 'This event has already started.');
    }

    final removed = await Attendance.db.deleteWhere(
      session,
      where: (t) => t.eventId.equals(eventId) & t.userId.equals(userId),
    );
    if (removed.isEmpty) {
      throw SpotException(message: "You haven't joined this event.");
    }
    return getEvent(session, eventId);
  }

  /// Cancels an upcoming event. Host only.
  Future<EventView> cancelEvent(Session session, int eventId) async {
    final userId = _userId(session);
    final event = await _findEvent(session, eventId);
    if (event.hostId != userId) {
      throw SpotException(message: 'Only the host can cancel this event.');
    }
    if (event.status == EventStatus.cancelled) {
      throw SpotException(message: 'This event is already cancelled.');
    }
    if (!event.startsAt.isAfter(DateTime.now().toUtc())) {
      throw SpotException(message: 'This event has already started.');
    }

    final cancelled = await Event.db.updateRow(
      session,
      event.copyWith(status: EventStatus.cancelled),
    );
    return (await _views(session, [cancelled], userId)).single;
  }

  /// Events the caller hosts and has joined. Upcoming first (soonest first),
  /// then past events (most recent first).
  Future<MyEvents> getMyEvents(Session session) async {
    final userId = _userId(session);

    final hosting = await Event.db.find(
      session,
      where: (t) => t.hostId.equals(userId),
    );
    final joinedIds = (await Attendance.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    )).map((a) => a.eventId).toSet();
    final joined = joinedIds.isEmpty
        ? <Event>[]
        : await Event.db.find(session, where: (t) => t.id.inSet(joinedIds));

    return MyEvents(
      hosting: await _views(session, _upcomingFirst(hosting), userId),
      joined: await _views(session, _upcomingFirst(joined), userId),
    );
  }

  /// Who has joined the event, earliest first. Host only.
  Future<List<AttendeeInfo>> getAttendees(Session session, int eventId) async {
    final userId = _userId(session);
    final event = await _findEvent(session, eventId);
    if (event.hostId != userId) {
      throw SpotException(message: 'Only the host can see the attendee list.');
    }

    final rows = await Attendance.db.find(
      session,
      where: (t) => t.eventId.equals(eventId),
      orderBy: (t) => t.joinedAt,
    );
    final names = await _displayNames(session, rows.map((a) => a.userId));
    return [
      for (final a in rows)
        AttendeeInfo(
          userId: a.userId,
          name: names[a.userId] ?? 'Spot user',
          joinedAt: a.joinedAt,
        ),
    ];
  }

  // ---------------------------------------------------------------------------

  UuidValue _userId(Session session) {
    final id = session.authenticated?.authUserId;
    if (id == null) throw SpotException(message: 'Please sign in.');
    return id;
  }

  Future<Event> _findEvent(Session session, int id) async {
    final event = await Event.db.findById(session, id);
    if (event == null) throw SpotException(message: 'Event not found.');
    return event;
  }

  /// Adds attendee counts, spots left and the caller's relation to [events].
  Future<List<EventView>> _views(
    Session session,
    List<Event> events,
    UuidValue userId, {
    double? lat,
    double? lng,
  }) async {
    if (events.isEmpty) return [];
    final ids = events.map((e) => e.id!).toSet();
    final attendance = await Attendance.db.find(
      session,
      where: (t) => t.eventId.inSet(ids),
    );

    final counts = <int, int>{};
    final mine = <int>{};
    for (final a in attendance) {
      counts.update(a.eventId, (c) => c + 1, ifAbsent: () => 1);
      if (a.userId == userId) mine.add(a.eventId);
    }

    return [
      for (final e in events)
        EventView(
          event: e,
          distanceKm: lat != null && lng != null
              ? haversineKm(lat, lng, e.lat, e.lng)
              : null,
          attendeeCount: counts[e.id] ?? 0,
          spotsLeft: (e.capacity - (counts[e.id] ?? 0)).clamp(0, e.capacity),
          joinedByMe: mine.contains(e.id),
          hostedByMe: e.hostId == userId,
        ),
    ];
  }

  List<Event> _upcomingFirst(List<Event> events) {
    final now = DateTime.now().toUtc();
    final upcoming = events.where((e) => e.startsAt.isAfter(now)).toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    final past = events.where((e) => !e.startsAt.isAfter(now)).toList()
      ..sort((a, b) => b.startsAt.compareTo(a.startsAt));
    return [...upcoming, ...past];
  }

  Future<String> _displayName(Session session, UuidValue userId) async =>
      (await _displayNames(session, [userId]))[userId] ?? 'Spot host';

  /// Best available display name per user: full name, user name, or the part
  /// of the email before the @.
  Future<Map<UuidValue, String>> _displayNames(
    Session session,
    Iterable<UuidValue> userIds,
  ) async {
    final ids = userIds.toSet();
    if (ids.isEmpty) return {};
    final profiles = await UserProfile.db.find(
      session,
      where: (t) => t.authUserId.inSet(ids),
    );
    return {for (final p in profiles) p.authUserId: ?_nameOf(p)};
  }

  String? _nameOf(UserProfile p) {
    for (final n in [p.fullName, p.userName]) {
      if (n != null && n.trim().isNotEmpty) return n.trim();
    }
    final email = p.email;
    if (email != null && email.contains('@')) return email.split('@').first;
    return null;
  }
}
