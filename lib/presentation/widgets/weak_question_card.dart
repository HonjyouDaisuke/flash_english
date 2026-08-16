import 'package:flash_english/domain/entities/question.dart';
import 'package:flash_english/domain/entities/question_stats.dart';
import 'package:flutter/material.dart';

class WeakQuestionCard extends StatelessWidget {
  final Question question;
  final QuestionStats stats;

  const WeakQuestionCard({
    super.key,
    required this.question,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final total = stats.correctCount + stats.wrongCount;

    final accuracy = total == 0 ? 0.0 : stats.correctCount / total;

    final accuracyPercent = (accuracy * 100).round();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.japanese,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              question.english,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _AccuracyBadge(
                  accuracyPercent: accuracyPercent,
                ),
                Text('正解 ${stats.correctCount}回'),
                Text('不正解 ${stats.wrongCount}回'),
                Text(
                  '[カテゴリ ${question.categoryNo}, ユニット ${question.unitNo}, 問題番号 ${question.questionNo}]',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AccuracyBadge extends StatelessWidget {
  final int accuracyPercent;

  const _AccuracyBadge({
    required this.accuracyPercent,
  });

  @override
  Widget build(BuildContext context) {
    final isWeak = accuracyPercent < 50;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isWeak
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '正答率 $accuracyPercent%',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isWeak
              ? Theme.of(context).colorScheme.onErrorContainer
              : Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
