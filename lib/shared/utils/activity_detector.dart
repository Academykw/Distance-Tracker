import '../models/session_model.dart';

/// Classifies activity type from current speed.
/// Thresholds:  idle < 0.3 m/s | walk < 2.0 | jog < 4.0 | run ≥ 4.0
class ActivityDetector {
  static ActivityType fromSpeed(double speedMs) {
    if (speedMs < 0.3) return ActivityType.unknown;
    if (speedMs < 2.0) return ActivityType.walk;
    if (speedMs < 4.0) return ActivityType.jog;
    return ActivityType.run;
  }

  static String emoji(ActivityType type) => switch (type) {
    ActivityType.walk    => '🚶',
    ActivityType.jog     => '🏃',
    ActivityType.run     => '🏃‍💨',
    ActivityType.unknown => '—',
  };
}
