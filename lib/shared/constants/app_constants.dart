class AppConstants {
  // GPS accuracy threshold — discard noisy readings above this
  static const double maxAccuracyMeters  = 20.0;

  // Speed below this = device is considered stationary
  static const double minMovementSpeedMs = 0.3;

  // Activity speed thresholds (m/s)
  static const double walkMaxSpeedMs = 2.0;
  static const double jogMaxSpeedMs  = 4.0;

  // Fire a split notification every N metres
  static const double splitDistanceMeters = 1000.0;

  // Minimum waypoints before distance is considered valid
  static const int minWaypointsForSession = 2;
}
