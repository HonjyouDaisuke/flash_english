import 'package:flash_english/presentation/controllers/game_controller.dart';
import 'package:flash_english/presentation/states/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UnitFinishPage extends ConsumerWidget {
  const UnitFinishPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameControllerProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final total = game.answers.length;
    final correct =
        game.answers.where((a) => a.result == AnswerResult.correct).length;
    final wrong = total - correct;

    final accuracy =
        total > 0 ? (correct / total * 100).toStringAsFixed(1) : '0.0';
    final stars = game.stars;

    return Scaffold(
      appBar: AppBar(title: const Text('結果')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'お疲れ様！',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),

            /// ⭐ スコア
            Text(
              '$accuracy%',
              style: theme.textTheme.displayLarge?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// ⭐ 詳細
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _resultCard('正解', correct, cs.tertiary),
                _resultCard('不正解', wrong, cs.error),
              ],
            ),

            const SizedBox(height: 30),

            /// ⭐ 星（例）
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final star = stars;
                return Icon(
                  i < star ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 40,
                );
              }),
            ),

            const SizedBox(height: 30),

            /// ⭐ New Record
            if (game.isNewRecord) ...[
              Text(
                '🎉 NEW RECORD!',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: cs.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
            ],

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/training');
                    },
                    child: const Text('メニュー'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/training/category');
                    },
                    child: const Text('カテゴリー'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.go(
                          '/training/category/unit?categoryId=${game.categoryId}');
                    },
                    child: const Text('ユニット選択'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultCard(String label, int value, Color color) {
    return Column(
      children: [
        Text(label),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
