import 'package:flash_english/domain/repositories/study_log_repository.dart';
import 'package:flash_english/infrastructure/repositories/study_log_repository_impl.dart';
import 'package:flash_english/presentation/providers/study_log_local_data_source_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studyLogRepositoryProvider = Provider<StudyLogRepository>((ref) {
  final ds = ref.read(studyLogLocalDataSourceProvider);
  return StudyLogRepositoryImpl(ds);
});
