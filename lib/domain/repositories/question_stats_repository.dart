import 'package:flash_english/domain/entities/question_stats.dart';

abstract class QuestionStatsRepository {
  Future<List<QuestionStats>> getAllQuestionStats();
  Future<void> insertQuestionStats(Map<String, dynamic> map);
  Future<void> upsertAll(List<QuestionStats> stats);
  Future<List<QuestionStats>> getAllApi(String userId);
}
