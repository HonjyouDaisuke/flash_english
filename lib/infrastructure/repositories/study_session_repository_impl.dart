import 'package:flash_english/domain/entities/study_session.dart';
import 'package:flash_english/domain/repositories/study_session_repository.dart';
import 'package:sqflite/sqflite.dart';

class StudySessionRepositoryImpl implements StudySessionRepository {
  final Database db;

  StudySessionRepositoryImpl(this.db);

  @override
  Future<List<StudySession>> getSessionsByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final maps = await db.query(
      'study_sessions',
      where: 'started_at >= ? AND started_at < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );
    return maps.map((m) {
      return StudySession(
        id: (m['id'] ?? 0) as int,
        startedAt: DateTime.parse(m['started_at'] as String),
        endedAt: m['ended_at'] != null
            ? DateTime.parse(m['ended_at'] as String)
            : null,
      );
    }).toList();
  }
}
