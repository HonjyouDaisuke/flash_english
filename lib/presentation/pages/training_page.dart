import 'package:flash_english/domain/entities/auth_status.dart';
import 'package:flash_english/presentation/controllers/game_controller.dart';
import 'package:flash_english/presentation/providers/auth/auth_provider.dart';
import 'package:flash_english/presentation/providers/unit/get_unit_description_provider.dart';
import 'package:flash_english/presentation/providers/training_provider.dart';
import 'package:flash_english/presentation/providers/user_setting/user_settings_provider.dart';
import 'package:flash_english/presentation/states/game_state.dart';
import 'package:flash_english/presentation/widgets/flash_card_widget.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TrainingPage extends ConsumerStatefulWidget {
  final int? categoryNo;
  final int? unitNo;
  const TrainingPage({super.key, this.categoryNo, this.unitNo});

  @override
  ConsumerState<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends ConsumerState<TrainingPage> {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    debugPrint(
        'TrainingPage initState: categoryNo=${widget.categoryNo}, unitNo=${widget.unitNo}');

    Future.microtask(() async {
      await ref
          .read(gameControllerProvider.notifier)
          .start(categoryNo: widget.categoryNo!, unitNo: widget.unitNo!);
      // 👇 初回だけ手動トリガー
      if (!mounted) return;

      final notifier = ref.read(trainingProvider.notifier);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAutoFlip(
          notifier,
          _waitingTime(),
        );
      });
    });
  }

  Duration _waitingTime() {
    final settings = ref.read(userSettingsProvider);
    final parsed = int.tryParse(settings['answer_wait'] ?? '3') ?? 3;
    final seconds = parsed < 1 ? 1 : (parsed > 10 ? 10 : parsed);

    return Duration(seconds: seconds);
  }

  void _startAutoFlip(
    TrainingNotifier notifier,
    Duration waitingTime,
  ) async {
    debugPrint("Auto flip will start after ${waitingTime.inSeconds} seconds");
    final start = ref.read(trainingProvider);
    if (start.questions.isEmpty || !start.isFront) return;
    await notifier.playFrontAndWait();
    if (!mounted) return;
    final afterPlay = ref.read(trainingProvider);
    if (afterPlay.questions.isEmpty ||
        afterPlay.currentIndex != start.currentIndex ||
        !afterPlay.isFront) {
      return;
    }

    await Future.delayed(waitingTime);

    if (!mounted) return;
    final beforeFlip = ref.read(trainingProvider);
    if (beforeFlip.questions.isEmpty ||
        beforeFlip.currentIndex != start.currentIndex ||
        !beforeFlip.isFront) {
      return;
    }
    notifier.flip(false);
  }

  void _syncCard(bool isFront) {
    final card = _cardKey.currentState;
    if (card == null) return;

    if (isFront != card.isFront) {
      _isSyncing = true; // 👈 ここ重要
      card.toggleCard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trainingProvider);
    final game = ref.watch(gameControllerProvider);
    final auth = ref.watch(authProvider);
    final notifier = ref.read(trainingProvider.notifier);
    final gameController = ref.read(gameControllerProvider.notifier);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final current = game.currentQuestionPos + 1;
    final total = state.questions.length;
    final progress = current / total;

    ref.listen(trainingProvider, (prev, next) {
      if (prev?.currentIndex != next.currentIndex) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _syncCard(true);
          _startAutoFlip(notifier, _waitingTime());
        });
      }

      if (prev?.isFront != next.isFront) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _syncCard(next.isFront);
        });
      }
    });
    ref.listen(gameControllerProvider, (prev, next) {
      if (prev?.phase != GamePhase.finished &&
          next.phase == GamePhase.finished) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/training/unit-finish');
        });
      }
    });
    if (game.phase == GamePhase.loading ||
        state.isLoading ||
        state.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final q = state.current;
    final unitDescAnsync = ref.watch(unitDescriptionProvider(
        (categoryNo: widget.categoryNo!, unitNo: widget.unitNo!)));
    return Scaffold(
      appBar: AppBar(
          title: unitDescAnsync.when(
        data: (desc) => Text(
          '$desc ${(auth.status == AuthStatus.offlineAuthExpired || auth.status == AuthStatus.offlineAuthenticated) ? "(オフライン)" : "(オンライン)"}',
        ),
        loading: () => const Text('Loading...'),
        error: (_, __) => const Text('Error...'),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("問題 $current/$total"),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: cs.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(cs.primary),
              ),
            ),
            const SizedBox(height: 20),
            FlashCardWidget(
              cardKey: _cardKey,
              frontText: q.japanese,
              backText: q.english,
              frontAudio: q.japaneseAudio,
              backAudio: q.englishAudio,
              onFlip: (isFront) {
                if (_isSyncing) {
                  _isSyncing = false; // 👈 同期由来なので無視
                  return;
                }
                notifier.flip(isFront); // 👈 ユーザー操作のみ反映
              },
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton.filled(
                icon: const Icon(Icons.fast_rewind),
                style: IconButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                ),
                onPressed: () {
                  ref.read(gameControllerProvider.notifier).prev();
                },
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
                    debugPrint("pushed 不正解");
                    gameController.answer(state.currentIndex, false);
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
                    gameController.answer(state.currentIndex, true);
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
                  onPressed: () {
                    gameController.next();
                  }),
            ]),
          ],
        ),
      ),
    );
  }
}
