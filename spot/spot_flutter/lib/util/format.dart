import 'package:intl/intl.dart';
import 'package:spot_client/spot_client.dart';

String formatDistance(double? km) {
  if (km == null) return '';
  if (km < 1) return '${(km * 1000).round()} m';
  return '${km.toStringAsFixed(km < 10 ? 1 : 0)} km';
}

/// "Today · 6:30 PM", "Tomorrow · 10:00 AM" or "Sat 12 Oct · 7:00 PM",
/// in the device's local time.
String formatWhen(DateTime utc) {
  final t = utc.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(t.year, t.month, t.day);
  final diff = day.difference(today).inDays;
  final time = DateFormat.jm().format(t);
  final date = switch (diff) {
    0 => 'Today',
    1 => 'Tomorrow',
    _ => DateFormat('EEE d MMM').format(t),
  };
  return '$date · $time';
}

/// "Saturday, 12 October 2026 · 7:00 PM"
String formatWhenLong(DateTime utc) {
  final t = utc.toLocal();
  return '${DateFormat('EEEE, d MMMM y').format(t)} · ${DateFormat.jm().format(t)}';
}

String spotsLeftLabel(EventView v) {
  if (v.event.status == EventStatus.cancelled) return 'Cancelled';
  if (v.spotsLeft == 0) return 'Full';
  return v.spotsLeft == 1 ? '1 spot left' : '${v.spotsLeft} spots left';
}

/// Turns any error from the server into a sentence that's safe to show.
String friendlyError(Object error) {
  if (error is SpotException) return error.message;
  final s = error.toString();
  if (s.contains('SocketException') ||
      s.contains('Connection refused') ||
      s.contains('ServerpodClientException') && s.contains('statusCode = -1')) {
    return "Can't reach Spot right now. Check your connection and try again.";
  }
  return 'Something went wrong. Please try again.';
}
