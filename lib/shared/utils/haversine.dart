import 'dart:math';

/// Great-circle distance between two GPS coordinates, in metres.
/// Uses the Haversine formula — the same method used by Google Maps.
/// Accuracy: <0.5% error for typical run/walk distances.
double haversineMeters(
  double lat1, double lon1,
  double lat2, double lon2,
) {
  const earthRadiusM = 6371000.0;
  final dLat = _rad(lat2 - lat1);
  final dLon = _rad(lon2 - lon1);
  final a = pow(sin(dLat / 2), 2) +
      cos(_rad(lat1)) * cos(_rad(lat2)) * pow(sin(dLon / 2), 2);
  return earthRadiusM * 2 * atan2(sqrt(a), sqrt(1 - a));
}

double _rad(double deg) => deg * pi / 180;
