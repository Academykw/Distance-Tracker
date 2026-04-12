// A GPS coordinate captured during a session
class WaypointModel {
  final double latitude;
  final double longitude;
  final double accuracyMeters;
  final double speedMs;           // metres per second at capture time
  final DateTime timestamp;

  const WaypointModel({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.speedMs,
    required this.timestamp,
  });
}
