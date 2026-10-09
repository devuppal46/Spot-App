import 'dart:math' as math;

const _earthRadiusKm = 6371.0;

/// Great-circle distance between two points, in kilometres.
double haversineKm(double lat1, double lng1, double lat2, double lng2) {
  final dLat = _rad(lat2 - lat1);
  final dLng = _rad(lng2 - lng1);
  final a =
      math.pow(math.sin(dLat / 2), 2) +
      math.cos(_rad(lat1)) *
          math.cos(_rad(lat2)) *
          math.pow(math.sin(dLng / 2), 2);
  return 2 * _earthRadiusKm * math.asin(math.sqrt(a));
}

/// A lat/lng box that fully contains the circle of [radiusKm] around a point.
/// Used to narrow the database query before the exact distance check.
({double minLat, double maxLat, double minLng, double maxLng}) boundingBox(
  double lat,
  double lng,
  double radiusKm,
) {
  final dLat = radiusKm / 111.0;
  final dLng = radiusKm / (111.0 * math.cos(_rad(lat)).abs().clamp(0.01, 1));
  return (
    minLat: lat - dLat,
    maxLat: lat + dLat,
    minLng: lng - dLng,
    maxLng: lng + dLng,
  );
}

double _rad(double deg) => deg * math.pi / 180;
