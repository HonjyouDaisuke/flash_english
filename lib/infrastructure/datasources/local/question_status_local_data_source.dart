import 'package:flash_english/domain/entities/question_stats.dart';
import 'package:sqflite/sqflite.dart';

class QuestionStatsLocalDataSource {
  final Database db;

  QuestionStatsLocalDataSource(this.db);

  Future<List<QuestionStats>> getAll() async {
    final maps = await db.query(
      'question_stats',
    );

    return maps
        .map(
          (m) => QuestionStats(
            questionId: (m['question_id'] ?? 0) as int,
            categoryNo: (m['category_no'] ?? 0) as int,
            unitNo: (m['unit_no'] ?? 0) as int,
            questionNo: (m['question_no'] ?? 0) as int,
            correctCount: (m['correct_count'] ?? 0) as int,
            wrongCount: (m['wrong_count'] ?? 0) as int,
            createdAt: m['created_at'] != null
                ? DateTime.parse(m['created_at'] as String)
                : DateTime.now(),
          ),
        )
        .toList();
  }

  Future<void> insertQuestionStats(Map<String, dynamic> map) async {
    await db.insert(
      'question_stats',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
