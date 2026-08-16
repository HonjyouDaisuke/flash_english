import 'package:flash_english/domain/entities/question.dart';
import 'package:flash_english/domain/entities/question_stats.dart';
import 'package:flash_english/presentation/providers/question/get_question_from_id_usecase_provider.dart';
import 'package:flash_english/presentation/providers/study_log/question_stats_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeakQuestion {
  final Question question;
  final QuestionStats stats;

  const WeakQuestion({
    required this.question,
    required this.stats,
  });
}

final weakQuestionsProvider = FutureProvider<List<WeakQuestion>>((ref) async {
  final stats = await ref.watch(questionStatsProvider.future);

  final getQuestion = ref.watch(getQuestionFromIdUseCaseProvider);

  final weakStats = stats.where((stat) => stat.wrongCount > 0).toList()
    ..sort((a, b) {
      final aTotal = a.correctCount + a.wrongCount;
      final bTotal = b.correctCount + b.wrongCount;

      final aAccuracy = aTotal == 0 ? 1.0 : a.correctCount / aTotal;
      final bAccuracy = bTotal == 0 ? 1.0 : b.correctCount / bTotal;

      return aAccuracy.compareTo(bAccuracy);
    });

  final result = <WeakQuestion>[];

  for (final stat in weakStats) {
    try {
      final question = await getQuestion.execute(
        questionId: stat.questionId,
      );

      result.add(
        WeakQuestion(
          question: question,
          stats: stat,
        ),
      );
    } catch (e) {
      // 問題マスタにまだ存在しない問題はスキップする
      continue;
    }
  }

  return result;
});
