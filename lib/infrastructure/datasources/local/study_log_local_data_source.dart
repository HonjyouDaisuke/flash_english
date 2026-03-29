import 'package:sqflite/sqflite.dart';

class StudyLogLocalDataSource {
  final Database db;

  StudyLogLocalDataSource(this.db);

  Future<List<Map<String, dynamic>>> getAllLogs() async {
    return await db.query('study_logs');
  }

  Future<void> insertLog(Map<String, dynamic> map) async {
    await db.insert('study_logs', map);
  }
}
