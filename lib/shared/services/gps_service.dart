import 'package:geolocator/geolocator.dart';
import '../models/waypoint_model.dart';
import '../constants/app_constants.dart';

class GpsService {
  static const _settings = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 3,          // emit only when device has moved ≥ 3 m
  );

  /// Filtered stream of waypoints — noisy GPS readings are dropped.
  Stream<WaypointModel> get positionStream =>
      Geolocator.getPositionStream(locationSettings: _settings)
          .where((p) => p.accuracy <= AppConstants.maxAccuracyMeters)
          .map((p) => WaypointModel(
                latitude:       p.latitude,
                longitude:      p.longitude,
                accuracyMeters: p.accuracy,
                speedMs:        p.speed.clamp(0, double.infinity),
                timestamp:      p.timestamp,
              ));

  Future<bool> requestPermission() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    return perm == LocationPermission.always ||
           perm == LocationPermission.whileInUse;
  }
}
