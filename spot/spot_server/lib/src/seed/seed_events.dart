import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Host id used for all seeded events. It does not belong to a real account,
/// so nobody can sign in as the seed host.
final seedHostId = UuidValue.fromString('00000000-5eed-7000-8000-000000000001');

/// Inserts ~12 upcoming demo events across Delhi.
///
/// Safe to run any number of times: an event is skipped when the seed host
/// already has an upcoming, open event with the same title. Returns the
/// number of events inserted.
Future<int> seedEvents(Session session, {DateTime? now}) async {
  now ??= DateTime.now().toUtc();
  final today = DateTime.utc(now.year, now.month, now.day);

  final existing = await Event.db.find(
    session,
    where: (t) =>
        t.hostId.equals(seedHostId) &
        t.status.equals(EventStatus.open) &
        (t.startsAt > now!),
  );
  final existingTitles = existing.map((e) => e.title).toSet();

  final toInsert = <Event>[
    for (final s in _seeds)
      if (!existingTitles.contains(s.title))
        Event(
          title: s.title,
          description: s.description,
          category: s.category,
          startsAt: _istToUtc(today, s.inDays, s.hour, s.minute),
          lat: s.lat,
          lng: s.lng,
          locationName: s.place,
          capacity: s.capacity,
          hostId: seedHostId,
          hostName: s.host,
        ),
  ].where((e) => e.startsAt.isAfter(now!)).toList();

  if (toInsert.isEmpty) return 0;
  await Event.db.insert(session, toInsert);
  return toInsert.length;
}

/// [hour]:[minute] India time, [days] after [todayUtc]'s date.
DateTime _istToUtc(DateTime todayUtc, int days, int hour, int minute) =>
    DateTime.utc(
      todayUtc.year,
      todayUtc.month,
      todayUtc.day + days,
      hour,
      minute,
    ).subtract(const Duration(hours: 5, minutes: 30));

typedef _Seed = ({
  String title,
  String description,
  EventCategory category,
  int inDays,
  int hour,
  int minute,
  double lat,
  double lng,
  String place,
  int capacity,
  String host,
});

const List<_Seed> _seeds = [
  (
    title: 'Is Delhi the best food city in India? — Open debate',
    description:
        'Two teams, one burning question. Bring your strongest arguments '
        '(and your favourite chaat spot). Moderated, friendly, loud. '
        'Snacks are on the losing side.',
    category: EventCategory.debate,
    inDays: 1,
    hour: 18,
    minute: 30,
    lat: 28.5535,
    lng: 77.1940,
    place: 'Kunzum Travel Café, Hauz Khas Village',
    capacity: 24,
    host: 'Riya Malhotra',
  ),
  (
    title: 'Sunday book swap & reading circle',
    description:
        'Bring a book you loved and swap it for one you haven\'t read. '
        'We read short passages aloud and talk about why they stuck with us. '
        'All languages welcome.',
    category: EventCategory.bookReading,
    inDays: 2,
    hour: 10,
    minute: 0,
    lat: 28.6328,
    lng: 77.2197,
    place: 'Central Park, Connaught Place',
    capacity: 20,
    host: 'Kabir Sethi',
  ),
  (
    title: 'Board games night: Catan, Codenames & chai',
    description:
        'Beginners welcome — we teach every game. Tables for 4–6 players. '
        'Chai and Maggi available at the café.',
    category: EventCategory.games,
    inDays: 2,
    hour: 19,
    minute: 0,
    lat: 28.5286,
    lng: 77.2190,
    place: 'Select Citywalk, Saket',
    capacity: 18,
    host: 'Ananya Rao',
  ),
  (
    title: 'Lajpat Nagar Diwali lights walk',
    description:
        'An evening stroll through the market\'s lights and stalls, with stops '
        'for jalebi and kachori. Meet at the metro gate 4. Wear comfy shoes.',
    category: EventCategory.festive,
    inDays: 3,
    hour: 18,
    minute: 0,
    lat: 28.5677,
    lng: 77.2433,
    place: 'Central Market, Lajpat Nagar',
    capacity: 30,
    host: 'Meher Kapoor',
  ),
  (
    title: 'Campus debate: Should attendance be optional?',
    description:
        'Parliamentary-style debate open to all colleges. Motion released '
        '15 minutes before. Teams formed on the spot — come solo or with friends.',
    category: EventCategory.debate,
    inDays: 4,
    hour: 16,
    minute: 0,
    lat: 28.6889,
    lng: 77.2090,
    place: 'Arts Faculty lawns, DU North Campus',
    capacity: 40,
    host: 'Debating Society, DU',
  ),
  (
    title: 'Poetry under the trees — Urdu & Hindi',
    description:
        'An unplugged reading of Faiz, Ghalib, Gulzar and your own work. '
        'Sign up for a 5-minute slot when you arrive, or just come to listen.',
    category: EventCategory.bookReading,
    inDays: 5,
    hour: 17,
    minute: 30,
    lat: 28.5931,
    lng: 77.2197,
    place: 'Lodhi Garden, near Khan Market',
    capacity: 25,
    host: 'Zoya Haider',
  ),
  (
    title: 'Chess in the park',
    description:
        'Casual and rapid games, all levels. A few boards provided; bring your '
        'own if you have one. Mini blitz tournament at 5 pm.',
    category: EventCategory.games,
    inDays: 6,
    hour: 15,
    minute: 0,
    lat: 28.5562,
    lng: 77.2003,
    place: 'Deer Park, Hauz Khas',
    capacity: 16,
    host: 'Arjun Mehta',
  ),
  (
    title: 'Khan Market bookshop crawl',
    description:
        'Faqir Chand, Bahrisons and a couple of hidden gems, with coffee in '
        'between. Each stop we share one recommendation.',
    category: EventCategory.bookReading,
    inDays: 7,
    hour: 11,
    minute: 0,
    lat: 28.6002,
    lng: 77.2270,
    place: 'Bahrisons Booksellers, Khan Market',
    capacity: 12,
    host: 'Kabir Sethi',
  ),
  (
    title: 'Quiz night: All things Delhi',
    description:
        'History, food, metro trivia and Bollywood. Teams of up to 4. '
        'Winning team picks next month\'s theme.',
    category: EventCategory.games,
    inDays: 8,
    hour: 20,
    minute: 0,
    lat: 28.6315,
    lng: 77.2167,
    place: 'The Imperial Spice, Connaught Place',
    capacity: 32,
    host: 'Ananya Rao',
  ),
  (
    title: 'Garba & dandiya evening',
    description:
        'Live dhol, beginner-friendly steps taught for the first 30 minutes. '
        'Dandiya sticks available. Traditional wear encouraged, not required.',
    category: EventCategory.festive,
    inDays: 10,
    hour: 19,
    minute: 0,
    lat: 28.5134,
    lng: 77.1980,
    place: 'Garden of Five Senses, Saket',
    capacity: 60,
    host: 'Meher Kapoor',
  ),
  (
    title: 'Street photography walk: Old & New',
    description:
        'From Kamla Nagar\'s lanes to the campus. Any camera or phone works. '
        'We\'ll share our favourite shots over momos at the end.',
    category: EventCategory.other,
    inDays: 11,
    hour: 8,
    minute: 0,
    lat: 28.6814,
    lng: 77.2051,
    place: 'Kamla Nagar Market, near North Campus',
    capacity: 15,
    host: 'Ishaan Verma',
  ),
  (
    title: 'Startup ideas: Friendly roast',
    description:
        'Pitch an idea in 2 minutes, get kind but honest feedback. '
        'Not a networking event — just people who like ideas.',
    category: EventCategory.debate,
    inDays: 13,
    hour: 18,
    minute: 30,
    lat: 28.5500,
    lng: 77.2050,
    place: 'Social, Hauz Khas Village',
    capacity: 20,
    host: 'Riya Malhotra',
  ),
];
