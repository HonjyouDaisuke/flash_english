import 'package:sqflite/sqflite.dart';

class UnitScoreLocalDataSource {
  final Database db;

  UnitScoreLocalDataSource(this.db);

  Future<List<Map<String, dynamic>>> getAllScores() async {
    return await db.query('unit_scores');
  }

  Future<void> saveScore(Map<String, dynamic> map) async {
    await db.insert('unit_scores', map);
  }
}
