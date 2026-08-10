import 'package:flash_english/domain/entities/study_log.dart';
import 'package:sqflite/sqflite.dart';

class StudyLogLocalDataSource {
  final Database db;

  StudyLogLocalDataSource(this.db);

  Future<List<Map<String, dynamic>>> getAllLogs() async {
    return await db.query('study_logs');
  }

  Future<List<Map<String, dynamic>>> getByPeriod(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await db.query(
      'study_logs',
      where: 'created_at >= ? AND created_at < ?',
      whereArgs: [
        startDate.toIso8601String(),
        endDate.add(const Duration(days: 1)).toIso8601String(),
      ],
      orderBy: 'created_at ASC',
    );
  }

  Future<void> insertLog(Map<String, dynamic> map) async {
    await db.insert('study_logs', map);
  }

  Future<DateTime?> getLatestCreatedAt() async {
    final result = await db.query(
      'study_logs',
      columns: ['created_at'],
      orderBy: 'created_at DESC',
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return DateTime.parse(result.first['created_at'] as String);
  }

  Future<void> upsertAll(List<StudyLog> logs) async {
    await db.transaction((txn) async {
      for (final log in logs) {
        await txn.insert(
          'study_logs',
          log.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
}
