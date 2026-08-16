import 'package:flash_english/presentation/providers/study_log/weak_questions_provider.dart';
import 'package:flash_english/presentation/widgets/weak_question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeakQuestionsPage extends ConsumerWidget {
  const WeakQuestionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weakQuestionsAsync = ref.watch(weakQuestionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('苦手問題'),
      ),
      body: weakQuestionsAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('苦手問題の取得に失敗しました。'),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => ref.invalidate(weakQuestionsProvider),
                  child: const Text('再試行'),
                ),
              ],
            ),
          );
        },
        data: (weakQuestions) {
          if (weakQuestions.isEmpty) {
            return const Center(
              child: Text('まだ苦手な問題はありません。'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: weakQuestions.length,
            separatorBuilder: (_, __) {
              return const SizedBox(height: 12);
            },
            itemBuilder: (context, index) {
              final item = weakQuestions[index];

              return WeakQuestionCard(
                question: item.question,
                stats: item.stats,
              );
            },
          );
        },
      ),
    );
  }
}
