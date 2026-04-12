import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// Convenience derived providers for the UI
final distanceProvider = Provider<double>((ref) {
  final state = ref.watch(trackingNotifierProvider);
  return state.currentSession?.totalMeters ?? 0.0;
});

final activityTypeProvider = Provider<ActivityType>((ref) {
  final state = ref.watch(trackingNotifierProvider);
  return state.currentSession?.activityType ?? ActivityType.unknown;
});

final currentSpeedProvider = Provider<double>((ref) {
  final state = ref.watch(trackingNotifierProvider);
  return state.lastWaypoint?.speedMs ?? 0.0;
});

final elapsedDurationProvider = Provider<Duration>((ref) {
  final state = ref.watch(trackingNotifierProvider);
  return state.currentSession?.elapsed ?? Duration.zero;
});

// ─── Notifier ────────────────────────────────────────────────────────────────

class TrackingNotifier extends StateNotifier<TrackingState> {
  final GpsService _gps;
  final AppDatabase _db;
  StreamSubscription<WaypointModel>? _gpsSub;
  final _uuid = const Uuid();

  TrackingNotifier(this._gps, this._db) : super(const TrackingState());

  // ── Public actions ──────────────────────────────────────────────────────

  Future<void> startTracking() async {
    final hasPermission = await _gps.requestPermission();
    if (!hasPermission) {
      state = state.copyWith(errorMessage: 'Location permission denied');
      return;
    }

    final session = SessionModel(
      id: _uuid.v4(),
      startTime: DateTime.now(),
    );

    // Persist new session row immediately
    await _db.insertSession(SessionsCompanion.insert(
      id: session.id,
      startTime: session.startTime.toIso8601String(),
    ));

    state = state.copyWith(
      status: TrackingStatus.active,
      currentSession: session,
      errorMessage: null,
    );

    _startListening(session.id);
  }

  void pauseTracking() {
    _gpsSub?.pause();
    state = state.copyWith(status: TrackingStatus.paused);
  }

  void resumeTracking() {
    _gpsSub?.resume();
    state = state.copyWith(status: TrackingStatus.active);
  }

  Future<void> stopTracking() async {
    _gpsSub?.cancel();
    _gpsSub = null;

    final session = state.currentSession;
    if (session == null) return;

    final finished = session.copyWith(endTime: DateTime.now());

    // Persist final state
    await _db.updateSession(SessionsCompanion(
      id: Value(finished.id),
      endTime: Value(finished.endTime?.toIso8601String()),
      totalMeters: Value(finished.totalMeters),
      activityType: Value(finished.activityType.name),
    ));

    state = state.copyWith(
      status: TrackingStatus.finished,
      currentSession: finished,
    );
  }

  void resetTracking() {
    state = const TrackingState();
  }

  void changeUnit(UnitType unit) {
    state = state.copyWith(displayUnit: unit);
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  void _startListening(String sessionId) {
    _gpsSub = _gps.positionStream.listen((waypoint) async {
      if (!mounted) return;

      final session = state.currentSession;
      if (session == null) return;

      // Calculate incremental distance from last known point
      double additionalMeters = 0.0;
      if (session.waypoints.isNotEmpty) {
        final last = session.waypoints.last;
        additionalMeters = haversineMeters(
          last.latitude, last.longitude,
          waypoint.latitude, waypoint.longitude,
        );
      }

      // Only accumulate if device is actually moving
      if (waypoint.speedMs < AppConstants.minMovementSpeedMs &&
          session.waypoints.isNotEmpty) {
        return;
      }

      final updatedWaypoints = [...session.waypoints, waypoint];
      final updatedMeters = session.totalMeters + additionalMeters;
      final activity = ActivityDetector.fromSpeed(waypoint.speedMs);

      final updatedSession = session.copyWith(
        waypoints: updatedWaypoints,
        totalMeters: updatedMeters,
        activityType: activity,
      );

      // Persist waypoint to DB
      await _db.insertWaypoint(WaypointsCompanion.insert(
        sessionId: sessionId,
        latitude: waypoint.latitude,
        longitude: waypoint.longitude,
        accuracy: waypoint.accuracyMeters,
        speedMs: waypoint.speedMs,
        timestamp: waypoint.timestamp.toIso8601String(),
      ));

      state = state.copyWith(
        currentSession: updatedSession,
        lastWaypoint: waypoint,
      );
    }, onError: (e) {
      state = state.copyWith(errorMessage: 'GPS error: $e');
    });
  }

  @override
  void dispose() {
    _gpsSub?.cancel();
    super.dispose();
  }
}
