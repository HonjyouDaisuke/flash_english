import 'package:flash_english/infrastructure/datasources/local/study_log_local_data_source.dart';
import 'package:flash_english/presentation/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studyLogLocalDataSourceProvider =
    Provider<StudyLogLocalDataSource>((ref) {
  final db = ref.read(databaseProvider);
  return StudyLogLocalDataSource(db);
});
