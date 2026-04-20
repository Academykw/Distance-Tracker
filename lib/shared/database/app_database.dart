
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'distance_tracker.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sessions (
            id TEXT PRIMARY KEY,
            start_time TEXT NOT NULL,
            end_time TEXT,
            total_meters REAL DEFAULT 0.0,
            activity_type TEXT DEFAULT 'unknown'
          )
        ''');
        await db.execute('''
          CREATE TABLE waypoints (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_id TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            accuracy REAL NOT NULL,
            speed_ms REAL NOT NULL,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertSession(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('sessions', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateSession(Map<String, dynamic> data) async {
    final db = await database;
    await db.update('sessions', data,
        where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<List<Map<String, dynamic>>> getAllSessions() async {
    final db = await database;
    return db.query('sessions', orderBy: 'start_time DESC');
  }

  Future<void> deleteSessionById(String id) async {
    final db = await database;
    await db.delete('waypoints', where: 'session_id = ?', whereArgs: [id]);
    await db.delete('sessions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertWaypoint(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('waypoints', data);
  }

  Future<List<Map<String, dynamic>>> getWaypointsForSession(
      String sessionId) async {
    final db = await database;
    return db.query('waypoints',
        where: 'session_id = ?',
        whereArgs: [sessionId],
        orderBy: 'timestamp ASC');
  }
}
