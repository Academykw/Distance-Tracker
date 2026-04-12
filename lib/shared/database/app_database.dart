import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ─── Table definitions ───────────────────────────────────────────────────────

class Sessions extends Table {
  TextColumn get id          => text()();
  TextColumn get startTime   => text()();           // ISO-8601
  TextColumn get endTime     => text().nullable()();
  RealColumn get totalMeters => real().withDefault(const Constant(0.0))();
  TextColumn get activityType=> text().withDefault(const Constant('unknown'))();

  @override
  Set<Column> get primaryKey => {id};
}

class Waypoints extends Table {
  IntColumn  get rowId      => integer().autoIncrement()();
  TextColumn get sessionId  => text()();
  RealColumn get latitude   => real()();
  RealColumn get longitude  => real()();
  RealColumn get accuracy   => real()();
  RealColumn get speedMs    => real()();
  TextColumn get timestamp  => text()();
}

// ─── Database class ───────────────────────────────────────────────────────────

@DriftDatabase(tables: [Sessions, Waypoints])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Sessions
  Future<List<Session>> getAllSessions() =>
      (select(sessions)..orderBy([(s) => OrderingTerm.desc(s.startTime)])).get();

  Future<Session?> getSessionById(String id) =>
      (select(sessions)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<void> insertSession(SessionsCompanion entry) =>
      into(sessions).insertOnConflictUpdate(entry);

  Future<void> updateSession(SessionsCompanion entry) =>
      (update(sessions)..where((s) => s.id.equals(entry.id.value)))
          .write(entry);

  Future<void> deleteSessionById(String id) async {
    await (delete(waypoints)..where((w) => w.sessionId.equals(id))).go();
    await (delete(sessions)..where((s) => s.id.equals(id))).go();
  }

  // Waypoints
  Future<void> insertWaypoint(WaypointsCompanion entry) =>
      into(waypoints).insert(entry);

  Future<List<Waypoint>> getWaypointsForSession(String sessionId) =>
      (select(waypoints)
            ..where((w) => w.sessionId.equals(sessionId))
            ..orderBy([(w) => OrderingTerm.asc(w.timestamp)]))
          .get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'distance_tracker.db'));
    return NativeDatabase.createInBackground(file);
  });
}
