import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:sqflite/sqflite.dart';

class UnitScoreLocalDataSource {
  final Database db;

  UnitScoreLocalDataSource(this.db);

  Future<List<Map<String, dynamic>>> getAllScores() async {
    return await db.query('unit_scores');
  }

  Future<List<UnitScore>> getAll() async {
    final maps = await db.query('unit_scores');
    return maps
        .map((m) => UnitScore(
              categoryNo: (m['category_no'] ?? 0) as int,
              unitNo: (m['unit_no'] ?? 0) as int,
              score: (m['score'] ?? 0) as int,
              achievedAt: m['achieved_at'] as String,
            ))
        .toList();
  }

  Future<void> saveScore(Map<String, dynamic> map) async {
    await db.insert(
      'unit_scores',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertAll(
    List<UnitScore> scores,
  ) async {
    await db.transaction((txn) async {
      for (final score in scores) {
        await txn.insert(
          'unit_scores',
          score.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
}
