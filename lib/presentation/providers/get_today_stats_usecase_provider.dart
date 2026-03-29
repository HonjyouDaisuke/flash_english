import 'package:flash_english/application/usecases/get_today_stats_usecase.dart';
import 'package:flash_english/presentation/providers/study_log_provider.dart';
import 'package:flash_english/presentation/providers/study_session_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTodayStatsUseCaseProvider = Provider((ref) {
  final logRepo = ref.read(studyLogRepositoryProvider);
  final sessionRepo = ref.read(studySessionRepositoryProvider);

  return GetTodayStatsUseCase(
    logRepo,
    sessionRepo,
  );
});
