import 'package:flash_english/application/usecases/sync_question_stats_usecase.dart';
import 'package:flash_english/presentation/providers/study_log/question_stats_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncQuestionStatsUseCaseProvider = Provider((ref) {
  final statsRepo = ref.watch(questionStatsRepositoryProvider);

  return SyncQuestionStatsUseCase(
    statsRepo,
  );
});
