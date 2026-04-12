import 'waypoint_model.dart';

// Represents one tracking session (run / jog / walk)
class SessionModel {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final double totalMeters;         // always stored as metres
  final ActivityType activityType;
  final List<WaypointModel> waypoints;

  const SessionModel({
    required this.id,
    required this.startTime,
    this.endTime,
    this.totalMeters = 0.0,
    this.activityType = ActivityType.unknown,
    this.waypoints = const [],
  });

  SessionModel copyWith({
    DateTime? endTime,
    double? totalMeters,
    ActivityType? activityType,
    List<WaypointModel>? waypoints,
  }) => SessionModel(
    id: id,
    startTime: startTime,
    endTime: endTime ?? this.endTime,
    totalMeters: totalMeters ?? this.totalMeters,
    activityType: activityType ?? this.activityType,
    waypoints: waypoints ?? this.waypoints,
  );

  Duration get elapsed =>
      (endTime ?? DateTime.now()).difference(startTime);
}

enum ActivityType { walk, jog, run, unknown }
