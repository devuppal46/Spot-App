import 'package:geolocator/geolocator.dart';

/// Where the app browses from: the device's position when it's inside Delhi,
/// otherwise Connaught Place.
class BrowseLocation {
  final double lat;
  final double lng;

  /// True when we fell back to Connaught Place.
  final bool isFallback;

  /// Why we fell back, shown under the "Browsing Delhi" banner.
  final String? reason;

  const BrowseLocation(
    this.lat,
    this.lng, {
    this.isFallback = false,
    this.reason,
  });

  static const connaughtPlace = BrowseLocation(
    28.6315,
    77.2167,
    isFallback: true,
  );

  BrowseLocation withReason(String reason) =>
      BrowseLocation(lat, lng, isFallback: isFallback, reason: reason);
}

/// Rough bounding box of the Delhi NCT.
bool isInDelhi(double lat, double lng) =>
    lat >= 28.40 && lat <= 28.89 && lng >= 76.83 && lng <= 77.35;

/// Resolves the location to browse from, never throwing.
Future<BrowseLocation> resolveBrowseLocation() async {
  const fallback = BrowseLocation.connaughtPlace;
  try {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return fallback.withReason('Location is turned off');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return fallback.withReason('Location permission not granted');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 8),
      ),
    );
    if (!isInDelhi(position.latitude, position.longitude)) {
      return fallback.withReason("You're outside Delhi");
    }
    return BrowseLocation(position.latitude, position.longitude);
  } catch (_) {
    return fallback.withReason("Couldn't get your location");
  }
}
