import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrainingMenuPage extends StatelessWidget {
  const TrainingMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: const Text('トレーニング')), // ← これも微妙
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.push('/training/normal');
                  },
                  child: const Text('通常トレーニング'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.push('/training/shuffle');
                  },
                  child: const Text('シャッフル'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
