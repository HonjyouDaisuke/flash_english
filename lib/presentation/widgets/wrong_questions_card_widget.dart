import 'package:flash_english/domain/entities/question.dart';
import 'package:flutter/material.dart';

class WrongQuestionsCard extends StatelessWidget {
  final List<Question> questions;

  const WrongQuestionsCard({
    super.key,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '今日の復習リスト',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (questions.isEmpty)
              const Text('🎉 今日の復習が必要な問題はありません！')
            else
              ...questions.map(
                (q) => ListTile(
                  dense: true,
                  leading: const Icon(Icons.error_outline),
                  title: Text(q.japanese),
                  subtitle: Text(q.english),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // 後で問題画面へ遷移
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
