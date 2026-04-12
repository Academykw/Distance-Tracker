enum UnitType { meters, kilometers, miles }

extension UnitTypeLabel on UnitType {
  String get label => switch (this) {
    UnitType.meters     => 'm',
    UnitType.kilometers => 'km',
    UnitType.miles      => 'mi',
  };

  String get fullName => switch (this) {
    UnitType.meters     => 'Meters',
    UnitType.kilometers => 'Kilometers',
    UnitType.miles      => 'Miles',
  };
}
