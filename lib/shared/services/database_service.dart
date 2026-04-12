// Implement with Drift (typed SQLite wrapper).
// This abstract class keeps the domain layer independent of the DB choice.
abstract class DatabaseService {
  Future<void> saveSession(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getAllSessions();
  Future<Map<String, dynamic>?> getSessionById(String id);
  Future<void> deleteSession(String id);
}
