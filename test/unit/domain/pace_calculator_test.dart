import 'package:flutter_test/flutter_test.dart';
import 'package:distance_tracker/shared/utils/pace_calculator.dart';

void main() {
  group('paceMinPerKm', () {
    test('returns null when speed is zero', () {
      expect(paceMinPerKm(0), isNull);
    });

    test('2.78 m/s (10 km/h) = 6:00 /km', () {
      final pace = paceMinPerKm(2.778);
      expect(pace, closeTo(6.0, 0.05));
    });

    test('5.0 m/s (18 km/h) = 3:20 /km', () {
      final pace = paceMinPerKm(5.0);
      expect(pace, closeTo(3.33, 0.05));
    });
  });

  group('formatPace', () {
    test('null speed shows dashes', () {
      expect(formatPace(null), '--:--');
    });

    test('6 min/km formats as 6:00 /km', () {
      expect(formatPace(6.0), '6:00 /km');
    });

    test('5.5 min/km formats as 5:30 /km', () {
      expect(formatPace(5.5), '5:30 /km');
    });
  });
}
