import 'package:flash_english/domain/enums/training_mode.dart';
import 'package:flash_english/presentation/providers/training_provider.dart';
import 'package:flash_english/presentation/widgets/flash_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingPage extends ConsumerStatefulWidget {
  final TrainingMode mode;

  const TrainingPage({super.key, required this.mode});

  @override
  ConsumerState<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends ConsumerState<TrainingPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(trainingProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trainingProvider);
    final notifier = ref.read(trainingProvider.notifier);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (state.isLoading || state.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final q = state.current;

    return Scaffold(
      appBar: AppBar(title: const Text('FlashEnglish')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("トレーニングモード : ${widget.mode}"),
            Text("問題 ${state.currentIndex + 1}/${state.questions.length}"),
            const SizedBox(height: 20),
            FlashCardWidget(
              key: ValueKey(state.currentIndex),
              frontText: q.japanese,
              backText: q.english,
              frontAudio: q.japaneseAudio,
              backAudio: q.englishAudio,
              onFlip: notifier.flip,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton.filled(
                icon: const Icon(Icons.fast_rewind),
                style: IconButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                ),
                onPressed: notifier.prev,
              ),
              const SizedBox(width: 20),
              if (!state.isFront) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('不正解'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.error,
                    foregroundColor: cs.onError,
                  ),
                  onPressed: () {
                    ref.read(trainingProvider.notifier).answer(false);
                  },
                ),
              ],
              const SizedBox(width: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.campaign),
                label: const Text('もう一度再生'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.secondary,
                  foregroundColor: cs.onSecondary,
                ),
                onPressed: () {
                  ref.read(trainingProvider.notifier).playCurrent();
                },
              ),
              const SizedBox(width: 20),
              if (!state.isFront) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('正解'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.tertiary,
                    foregroundColor: cs.onTertiary,
                  ),
                  onPressed: () {
                    ref.read(trainingProvider.notifier).answer(true);
                  },
                ),
              ],
              const SizedBox(width: 20),
              IconButton.filled(
                icon: const Icon(Icons.fast_forward),
                style: IconButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                ),
                onPressed: notifier.next,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
