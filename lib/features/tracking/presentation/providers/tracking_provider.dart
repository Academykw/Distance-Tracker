import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/database/app_database.dart';
import '../../../../shared/models/session_model.dart';
import '../../../../shared/models/unit_type.dart';
import '../../../../shared/models/waypoint_model.dart';
import '../../../../shared/services/gps_service.dart';
import '../../../../shared/utils/activity_detector.dart';
import '../../../../shared/utils/haversine.dart';
import '../../domain/models/tracking_state.dart';




final gpsServiceProvider = Provider<GpsService>((_) => GpsService());
final appDatabaseProvider = Provider<AppDatabase>((_) => AppDatabase());

final trackingNotifierProvider =
StateNotifierProvider<TrackingNotifier, TrackingState>(
      (ref) => TrackingNotifier(
    ref.read(gpsServiceProvider),
    ref.read(appDatabaseProvider),
  ),
);

// Convenience providers
final distanceProvider = Provider<double>(
      (ref) => ref.watch(trackingNotifierProvider).currentSession?.totalMeters ?? 0.0,
);
final activityTypeProvider = Provider<ActivityType>(
      (ref) => ref.watch(trackingNotifierProvider).currentSession?.activityType ?? ActivityType.unknown,
);
final currentSpeedProvider = Provider<double>(
      (ref) => ref.watch(trackingNotifierProvider).lastWaypoint?.speedMs ?? 0.0,
);
final elapsedDurationProvider = Provider<Duration>(
      (ref) => ref.watch(trackingNotifierProvider).elapsed,
);
final waypointsProvider = Provider<List<WaypointModel>>(
      (ref) => ref.watch(trackingNotifierProvider).currentSession?.waypoints ?? [],
);
final routePointsProvider = Provider<List<LatLng>>(
      (ref) {
    final wps = ref.watch(waypointsProvider);
    return wps.map((w) => LatLng(w.latitude, w.longitude)).toList();
  },
);

// ─── Notifier ─────────────────────────────────────────────────────────────────

class TrackingNotifier extends StateNotifier<TrackingState> {
  final GpsService _gps;
  final AppDatabase _db;
  StreamSubscription<WaypointModel>? _gpsSub;
  Timer? _timer;
  final _uuid = const Uuid();

  TrackingNotifier(this._gps, this._db) : super(const TrackingState());

  Future<void> startTracking() async {
    final hasPermission = await _gps.requestPermission();
    if (!hasPermission) {
      state = state.copyWith(errorMessage: 'Location permission denied. Please enable it in settings.');
      return;
    }

    final session = SessionModel(
      id: _uuid.v4(),
      startTime: DateTime.now(),
    );

    await _db.insertSession({
      'id': session.id,
      'start_time': session.startTime.toIso8601String(),
      'total_meters': 0.0,
      'activity_type': 'unknown',
    });

    state = state.copyWith(
      status: TrackingStatus.active,
      currentSession: session,
      errorMessage: null,
    );

    // Start a timer that fires every second to update elapsed time in UI
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.status == TrackingStatus.active) {
        // Trigger rebuild by updating state with same session (elapsed recalculates from startTime)
        state = state.copyWith(tickTime: DateTime.now());
      }
    });

    _startGpsListening(session.id);
  }

  void pauseTracking() {
    _gpsSub?.pause();
    _timer?.cancel();
    state = state.copyWith(status: TrackingStatus.paused);
  }

  void resumeTracking() {
    _gpsSub?.resume();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.status == TrackingStatus.active) {
        state = state.copyWith(tickTime: DateTime.now());
      }
    });
    state = state.copyWith(status: TrackingStatus.active);
  }

  Future<void> stopTracking() async {
    _gpsSub?.cancel();
    _gpsSub = null;
    _timer?.cancel();
    _timer = null;

    final session = state.currentSession;
    if (session == null) return;

    final finished = session.copyWith(endTime: DateTime.now());

    await _db.updateSession({
      'id': finished.id,
      'end_time': finished.endTime?.toIso8601String(),
      'total_meters': finished.totalMeters,
      'activity_type': finished.activityType.name,
    });

    state = state.copyWith(
      status: TrackingStatus.finished,
      currentSession: finished,
    );
  }

  void resetTracking() => state = const TrackingState();

  void changeUnit(UnitType unit) => state = state.copyWith(displayUnit: unit);

  void _startGpsListening(String sessionId) {
    _gpsSub = _gps.positionStream.listen(
          (waypoint) async {
        if (!mounted) return;

        final session = state.currentSession;
        if (session == null) return;

        // Accumulate distance only if moving
        double additionalMeters = 0.0;
        if (session.waypoints.isNotEmpty) {
          final last = session.waypoints.last;
          // Skip points that are too close (< 1m) to reduce noise
          final dist = haversineMeters(
            last.latitude, last.longitude,
            waypoint.latitude, waypoint.longitude,
          );
          if (dist < 1.0) return;
          additionalMeters = dist;
        }

        final updatedWaypoints = [...session.waypoints, waypoint];
        final updatedMeters = session.totalMeters + additionalMeters;
        final activity = ActivityDetector.fromSpeed(waypoint.speedMs);

        final updatedSession = session.copyWith(
          waypoints: updatedWaypoints,
          totalMeters: updatedMeters,
          activityType: activity,
        );

        // Save waypoint to DB (don't await — fire and forget to keep UI smooth)
        _db.insertWaypoint({
          'session_id': sessionId,
          'latitude': waypoint.latitude,
          'longitude': waypoint.longitude,
          'accuracy': waypoint.accuracyMeters,
          'speed_ms': waypoint.speedMs,
          'timestamp': waypoint.timestamp.toIso8601String(),
        });

        state = state.copyWith(
          currentSession: updatedSession,
          lastWaypoint: waypoint,
        );
      },
      onError: (e) {
        state = state.copyWith(errorMessage: 'GPS error: $e');
      },
    );
  }

  @override
  void dispose() {
    _gpsSub?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}
