import 'package:flash_english/infrastructure/datasources/local/question_status_local_data_source.dart';
import 'package:flash_english/presentation/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final questionStatsLocalDataSourceProvider =
    Provider<QuestionStatsLocalDataSource>((ref) {
  final db = ref.watch(databaseProvider);
  return QuestionStatsLocalDataSource(db);
});
