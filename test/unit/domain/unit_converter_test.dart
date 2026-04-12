import 'package:flutter_test/flutter_test.dart';
import 'package:distance_tracker/shared/utils/unit_converter.dart';
import 'package:distance_tracker/shared/models/unit_type.dart';

void main() {
  group('UnitConverter.convert', () {
    test('meters returns unchanged', () {
      expect(UnitConverter.convert(500, UnitType.meters), 500.0);
    });

    test('1000 m = 1.00 km', () {
      expect(UnitConverter.convert(1000, UnitType.kilometers), 1.0);
    });

    test('1609.344 m = 1.00 mile', () {
      expect(UnitConverter.convert(1609.344, UnitType.miles), closeTo(1.0, 0.001));
    });

    test('5000 m = 5.00 km', () {
      expect(UnitConverter.convert(5000, UnitType.kilometers), 5.0);
    });

    test('zero meters stays zero', () {
      expect(UnitConverter.convert(0, UnitType.miles), 0.0);
    });
  });

  group('UnitConverter.format', () {
    test('formats km with 2 decimals', () {
      expect(UnitConverter.format(5000, UnitType.kilometers), '5.00 km');
    });

    test('formats meters with no decimals', () {
      expect(UnitConverter.format(350, UnitType.meters), '350 m');
    });

    test('formats miles with 2 decimals', () {
      expect(UnitConverter.format(1609.344, UnitType.miles), '1.00 mi');
    });
  });
}
