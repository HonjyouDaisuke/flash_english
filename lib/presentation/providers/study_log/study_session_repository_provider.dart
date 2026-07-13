import 'package:flash_english/infrastructure/repositories/study_session_repository_impl.dart';
import 'package:flash_english/presentation/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studySessionRepositoryProvider = Provider((ref) {
  final db = ref.read(databaseProvider);
  return StudySessionRepositoryImpl(db);
});
