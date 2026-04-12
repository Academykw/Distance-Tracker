import 'package:distance_tracker/shared/models/session_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../tracking/presentation/providers/tracking_provider.dart';

final historyProvider = FutureProvider<List<SessionModel>>((ref) async{
  final db = ref.watch(appDatabaseProvider);
  ref.watch(trackingNotifierProvider);

  final rows = await db.getAllSessions();
  return rows.map((row){
    return SessionModel(
      id: row.id,
        startTime: DateTime.parse(row.startTime),
        endTime: row.endTime != null ? DateTime.parse(row.endTime!) :null,
        totalMeters: row.totalMeters,
        activityType: ActivityType.values.firstWhere(
          (a) => a.name == row.activityType,
          orElse: () => ActivityType.unknown,
        ),
    );
  }).toList();

});