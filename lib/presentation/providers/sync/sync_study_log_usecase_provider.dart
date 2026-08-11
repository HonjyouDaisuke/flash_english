import 'package:flash_english/application/usecases/sync_study_log_usecase.dart';
import 'package:flash_english/presentation/providers/study_log/study_log_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncStudyLogUseCaseProvider = Provider(
  (ref) => SyncStudyLogUseCase(
    ref.watch(studyLogRepositoryProvider),
  ),
);
