import 'package:flash_english/application/usecases/get_study_days_usecase.dart';
import 'package:flash_english/presentation/providers/study_log/study_log_provider.dart';
import 'package:flash_english/presentation/providers/study_log/study_session_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getStudyDaysUseCaseProvider = Provider((ref) {
  final logRepo = ref.watch(studyLogRepositoryProvider);
  final sessionRepo = ref.watch(studySessionRepositoryProvider);

  return GetStudyDaysUseCase(
    logRepo,
    sessionRepo,
  );
});
