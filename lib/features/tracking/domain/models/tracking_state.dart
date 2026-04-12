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

  const TrackingState({
    this.status = TrackingStatus.idle,
    this.currentSession,
    this.lastWaypoint,
    this.displayUnit = UnitType.kilometers,
    this.errorMessage,
  });

  bool get isActive => status == TrackingStatus.active;

  TrackingState copyWith({
    TrackingStatus? status,
    SessionModel? currentSession,
    WaypointModel? lastWaypoint,
    UnitType? displayUnit,
    String? errorMessage,
  }) => TrackingState(
    status:         status         ?? this.status,
    currentSession: currentSession ?? this.currentSession,
    lastWaypoint:   lastWaypoint   ?? this.lastWaypoint,
    displayUnit:    displayUnit    ?? this.displayUnit,
    errorMessage:   errorMessage,
  );
}
