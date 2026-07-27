import 'package:flash_english/application/usecases/get_today_stats_usecase.dart';
import 'package:flash_english/presentation/providers/question/questions_repository_provider.dart';
import 'package:flash_english/presentation/providers/study_log/study_log_provider.dart';
import 'package:flash_english/presentation/providers/study_log/study_session_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTodayStatsUseCaseProvider = Provider((ref) {
  final logRepo = ref.watch(studyLogRepositoryProvider);
  final sessionRepo = ref.watch(studySessionRepositoryProvider);
  final questionRepo = ref.watch(questionRepositoryProvider);

  return GetTodayStatsUseCase(
    logRepo,
    sessionRepo,
    questionRepo,
  );
});
