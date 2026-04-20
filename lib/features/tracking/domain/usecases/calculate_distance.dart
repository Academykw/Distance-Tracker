import '../../../../shared/models/waypoint_model.dart';
import '../../../../shared/utils/haversine.dart';

class CalculateDistance {
  /// Sums Haversine distances between consecutive waypoints.
  double call(List<WaypointModel> waypoints) {
    double total = 0.0;
    for (int i = 1; i < waypoints.length; i++) {
      total += haversineMeters(
        waypoints[i - 1].latitude, waypoints[i - 1].longitude,
        waypoints[i].latitude,     waypoints[i].longitude,
      );
    }
    return total;
  }
}
