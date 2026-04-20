import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../models/waypoint_model.dart';

class GpsService {
  /// Stream of all GPS positions - no distanceFilter so emulators work too.
  Stream<WaypointModel> get positionStream {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0, // emit every update so emulators + real devices both work
    );

    return Geolocator.getPositionStream(locationSettings: settings)
        .handleError((error) {
          // You could log this to a crash reporter or print for debugging
          print('GPS Stream Error: $error');
        })
        .map((p) => WaypointModel(
              latitude: p.latitude,
              longitude: p.longitude,
              accuracyMeters: p.accuracy,
              speedMs: p.speed < 0 ? 0 : p.speed,
              timestamp: p.timestamp,
            ));
  }

  /// Check permissions and request if necessary.
  /// Returns true if permission is granted (while in use or always).
  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Potentially open settings here if you want to be more proactive
      // await Geolocator.openLocationSettings();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try requesting permissions again
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Get the current one-off position.
  Future<Position?> getCurrentPosition() async {
    try {
      // Use direct parameters instead of locationSettings for getCurrentPosition
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  /// Utility to open app settings if permission is denied forever.
  Future<void> openSettings() async {
    await Geolocator.openAppSettings();
  }
}
