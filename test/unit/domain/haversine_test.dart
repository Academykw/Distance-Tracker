import 'package:flutter_test/flutter_test.dart';
import 'package:distance_tracker/shared/utils/haversine.dart';

void main() {
  group('haversineMeters', () {
    test('same point returns zero', () {
      expect(haversineMeters(6.5244, 3.3792, 6.5244, 3.3792), 0.0);
    });

    test('Lagos to Ikeja ~14 km', () {
      final d = haversineMeters(6.5244, 3.3792, 6.6018, 3.3515);
      expect(d, closeTo(14000, 1500));
    });

    test('1 degree latitude ≈ 111 km', () {
      final d = haversineMeters(0, 0, 1, 0);
      expect(d, closeTo(111195, 500));
    });

    test('short 100 m sprint', () {
      // ~0.0009 degrees lat ≈ 100 m
      final d = haversineMeters(6.5244, 3.3792, 6.5253, 3.3792);
      expect(d, closeTo(100, 20));
    });
  });
}
