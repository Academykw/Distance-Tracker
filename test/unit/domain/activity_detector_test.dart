import 'package:flutter_test/flutter_test.dart';
import 'package:distance_tracker/shared/utils/activity_detector.dart';
import 'package:distance_tracker/shared/models/session_model.dart';

void main() {
  group('ActivityDetector.fromSpeed', () {
    test('0.0 m/s → unknown (stationary)', () {
      expect(ActivityDetector.fromSpeed(0.0), ActivityType.unknown);
    });

    test('0.2 m/s → unknown (below movement threshold)', () {
      expect(ActivityDetector.fromSpeed(0.2), ActivityType.unknown);
    });

    test('1.2 m/s → walk', () {
      expect(ActivityDetector.fromSpeed(1.2), ActivityType.walk);
    });

    test('1.99 m/s → walk (boundary)', () {
      expect(ActivityDetector.fromSpeed(1.99), ActivityType.walk);
    });

    test('2.0 m/s → jog (boundary)', () {
      expect(ActivityDetector.fromSpeed(2.0), ActivityType.jog);
    });

    test('3.0 m/s → jog', () {
      expect(ActivityDetector.fromSpeed(3.0), ActivityType.jog);
    });

    test('4.0 m/s → run (boundary)', () {
      expect(ActivityDetector.fromSpeed(4.0), ActivityType.run);
    });

    test('6.0 m/s → run (sprinting)', () {
      expect(ActivityDetector.fromSpeed(6.0), ActivityType.run);
    });
  });
}
