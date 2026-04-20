import 'waypoint_model.dart';

class SessionModel {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final double totalMeters;
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

  /// Total elapsed time for the session
  Duration get elapsed {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  SessionModel copyWith({
    DateTime? endTime,
    double? totalMeters,
    ActivityType? activityType,
    List<WaypointModel>? waypoints,
  }) =>
      SessionModel(
        id: id,
        startTime: startTime,
        endTime: endTime ?? this.endTime,
        totalMeters: totalMeters ?? this.totalMeters,
        activityType: activityType ?? this.activityType,
        waypoints: waypoints ?? this.waypoints,
      );
}

enum ActivityType { walk, jog, run, unknown }
