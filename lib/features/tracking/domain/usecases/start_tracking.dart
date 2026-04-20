import '../../../../shared/services/gps_service.dart';

class StartTracking {
  final GpsService _gps;
  StartTracking(this._gps);

  /// Returns true if permissions are granted and tracking can begin.
  Future<bool> call() => _gps.requestPermission();
}
