import 'package:flash_english/domain/repositories/question_stats_repository.dart';
import 'package:flash_english/infrastructure/repositories/question_stats_repository_impl.dart';
import 'package:flash_english/presentation/providers/api_client_provider.dart';
import 'package:flash_english/presentation/providers/study_log/question_stats_local_data_source_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final questionStatsRepositoryProvider =
    Provider<QuestionStatsRepository>((ref) {
  final ds = ref.watch(questionStatsLocalDataSourceProvider);
  final apiClient = ref.watch(apiClientProvider);
  return QuestionStatsRepositoryImpl(ds, apiClient);
});
