import 'package:flash_english/presentation/providers/training_provider.dart';
import 'package:flash_english/presentation/states/game_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameControllerProvider =
    StateNotifierProvider.autoDispose<GameController, GameState>((ref) {
  return GameController(ref);
});

class GameController extends StateNotifier<GameState> {
  final Ref ref;

  GameController(this.ref) : super(GameState.initial());

  // ▶ スタート
  Future<void> start() async {
    state = state.copyWith(phase: GamePhase.loading);

    // 既存Providerで問題ロード
    await ref.read(trainingProvider.notifier).load();

    state = state.copyWith(
      phase: GamePhase.playing,
      currentIndex: 0,
      correctCount: 0,
      combo: 0,
      maxCombo: 0,
    );
  }

  // ▶ 回答
  Future<void> answer(bool isCorrect) async {
    if (state.phase != GamePhase.playing) return;

    // ① 自分の状態更新
    final newCorrect = isCorrect ? state.correctCount + 1 : state.correctCount;

    final newCombo = isCorrect ? state.combo + 1 : 0;

    final newMaxCombo = newCombo > state.maxCombo ? newCombo : state.maxCombo;

    state = state.copyWith(
      phase: GamePhase.feedback,
      correctCount: newCorrect,
      combo: newCombo,
      maxCombo: newMaxCombo,
      isCorrect: isCorrect,
    );

    // ② 既存Providerに保存させる（DB）
    await ref.read(trainingProvider.notifier).answer(isCorrect);

    // ③ 次へ or 終了
    await _nextOrFinish();
  }

  Future<void> _nextOrFinish() async {
    await Future.delayed(const Duration(milliseconds: 700));

    final trainingState = ref.read(trainingProvider);

    final isLast =
        trainingState.currentIndex >= trainingState.questions.length - 1;

    if (isLast) {
      _finish();
    } else {
      state = state.copyWith(
        phase: GamePhase.playing,
        currentIndex: trainingState.currentIndex,
      );
    }
  }

  // ▶ 終了処理
  void _finish() {
    final stars = _calculateStars(state.correctCount);
    final isNew = _isNewRecord(stars);

    state = state.copyWith(
      phase: GamePhase.result,
      stars: stars,
      isNewRecord: isNew,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      state = state.copyWith(phase: GamePhase.finished);
    });
  }

  // ▶ リトライ
  Future<void> retry() async {
    state = GameState.initial();
    await start();
  }

  // ▶ ★計算
  int _calculateStars(int correct) {
    if (correct == 10) return 5;
    if (correct >= 7) return 4;
    if (correct >= 5) return 3;
    if (correct >= 3) return 2;
    if (correct >= 1) return 1;
    return 0;
  }

  // ▶ ベスト判定（仮）
  bool _isNewRecord(int stars) {
    // TODO: DB連携
    final best = 3;
    return stars > best;
  }
}
