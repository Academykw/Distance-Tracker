 import 'package:distance_tracker/shared/services/database_service.dart';

import '../../../../shared/models/session_model.dart';

class TrackingRepository {
  final DatabaseService _db;
  TrackingRepository(this._db);
  Future<void> saveSession(SessionModel session) => _db.saveSession({
    'id':           session.id,
    'start_time':   session.startTime.toIso8601String(),
    'end_time':     session.endTime?.toIso8601String(),
    'total_meters': session.totalMeters,
    'activity':     session.activityType.name,
  });
 }