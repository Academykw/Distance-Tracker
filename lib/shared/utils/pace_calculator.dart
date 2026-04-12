/// Pace in minutes-per-km given speed in m/s. Null when stationary.
double? paceMinPerKm(double speedMs) {
  if (speedMs < 0.1) return null;
  return (1000 / speedMs) / 60;
}

/// e.g. "5:30 /km"
String formatPace(double? paceMinKm) {
  if (paceMinKm == null) return '--:--';
  final mins = paceMinKm.floor();
  final secs = ((paceMinKm - mins) * 60).round();
  return '$mins:${secs.toString().padLeft(2, '0')} /km';
}
