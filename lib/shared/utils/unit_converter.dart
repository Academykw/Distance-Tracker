import '../models/unit_type.dart';

class UnitConverter {
  static const double _metersPerKm   = 1000.0;
  static const double _metersPerMile = 1609.344;

  /// Convert a metre value to the target unit.
  static double convert(double meters, UnitType unit) => switch (unit) {
    UnitType.meters     => meters,
    UnitType.kilometers => meters / _metersPerKm,
    UnitType.miles      => meters / _metersPerMile,
  };

  /// Returns a formatted string, e.g. "3.45 km" or "2.14 mi".
  static String format(double meters, UnitType unit) {
    final value = convert(meters, unit);
    final decimals = unit == UnitType.meters ? 0 : 2;
    return '${value.toStringAsFixed(decimals)} ${unit.label}';
  }
}
