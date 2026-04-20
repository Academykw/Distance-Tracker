import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/database/app_database.dart';
import '../../../../shared/models/session_model.dart';
import '../../../tracking/presentation/providers/tracking_provider.dart';

final historyProvider = FutureProvider.autoDispose<List<SessionModel>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  // Re-fetch when tracking status changes
  ref.watch(trackingNotifierProvider.select((s) => s.status));

  final rows = await db.getAllSessions();
  return rows.map((row) => SessionModel(
    id: row['id'] as String,
    startTime: DateTime.parse(row['start_time'] as String),
    endTime: row['end_time'] != null ? DateTime.parse(row['end_time'] as String) : null,
    totalMeters: (row['total_meters'] as num).toDouble(),
    activityType: ActivityType.values.firstWhere(
      (a) => a.name == (row['activity_type'] as String),
      orElse: () => ActivityType.unknown,
    ),
  )).toList();
});
