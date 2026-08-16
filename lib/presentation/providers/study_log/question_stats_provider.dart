import 'package:flash_english/domain/entities/question_stats.dart';
import 'package:flash_english/presentation/providers/study_log/question_stats_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final questionStatsProvider = FutureProvider<List<QuestionStats>>((ref) async {
  final repository = ref.watch(questionStatsRepositoryProvider);
  return repository.getAllQuestionStats();
});
