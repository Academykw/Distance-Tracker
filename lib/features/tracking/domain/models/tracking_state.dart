import '../../../../shared/models/session_model.dart';
import '../../../../shared/models/unit_type.dart';
import '../../../../shared/models/waypoint_model.dart';

enum TrackingStatus { idle, active, paused, finished }

class TrackingState {
  final TrackingStatus status;
  final SessionModel? currentSession;
  final WaypointModel? lastWaypoint;
  final UnitType displayUnit;
  final String? errorMessage;
  final DateTime? tickTime; // updated every second to drive timer rebuilds

  const TrackingState({
    this.status = TrackingStatus.idle,
    this.currentSession,
    this.lastWaypoint,
    this.displayUnit = UnitType.kilometers,
    this.errorMessage,
    this.tickTime,
  });

  bool get isActive => status == TrackingStatus.active;

  /// Elapsed time — recalculates live from startTime so timer is accurate.
  Duration get elapsed {
    final session = currentSession;
    if (session == null) return Duration.zero;
    final end = (status == TrackingStatus.finished)
        ? (session.endTime ?? DateTime.now())
        : DateTime.now();
    return end.difference(session.startTime);
  }

  TrackingState copyWith({
    TrackingStatus? status,
    SessionModel? currentSession,
    WaypointModel? lastWaypoint,
    UnitType? displayUnit,
    String? errorMessage,
    DateTime? tickTime,
  }) =>
      TrackingState(
        status: status ?? this.status,
        currentSession: currentSession ?? this.currentSession,
        lastWaypoint: lastWaypoint ?? this.lastWaypoint,
        displayUnit: displayUnit ?? this.displayUnit,
        errorMessage: errorMessage,
        tickTime: tickTime ?? this.tickTime,
      );
}
