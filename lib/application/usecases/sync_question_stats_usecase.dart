import 'package:flash_english/domain/repositories/question_stats_repository.dart';

class SyncQuestionStatsUseCase {
  final QuestionStatsRepository repository;

  SyncQuestionStatsUseCase(this.repository);

  Future<void> execute(String userId) async {
    final stats = await repository.getAllApi(userId);
    await repository.upsertAll(stats);
  }
}
