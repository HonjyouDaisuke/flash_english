import 'package:flash_english/application/usecases/check_answer_usecase.dart';
import 'package:flash_english/application/usecases/get_questions_usecase.dart';
import 'package:flash_english/domain/entities/question.dart';
import 'package:flash_english/domain/enums/training_mode.dart';
import 'package:flash_english/infrastructure/repositories/question_repository_impl.dart';
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
  final TextEditingController _controller = TextEditingController();
  final _checkAnswerUseCase = CheckAnswerUseCase();
  late final GetQuestionsUseCase _getQuestionsUseCase;
  final GlobalKey<FlashCardWidgetState> _flipKey = GlobalKey();
  int currentIndex = 0;
  String result = "";
  bool isFront = true;

  List<Question> questions = [];
  bool isLoading = true;

  Question get currentQuestion => questions[currentIndex];

  @override
  void initState() {
    super.initState();

    final repository = QuestionRepositoryImpl();
    _getQuestionsUseCase = GetQuestionsUseCase(repository);

    load();
  }

  Future<void> load() async {
    try {
      final loaded = await _getQuestionsUseCase.execute();

      debugPrint("読み込み件数: ${loaded.length}");

      setState(() {
        questions = loaded;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("読み込みエラー: $e");
    }
  }

  void checkAnswer() {
    final isCorrect =
        _checkAnswerUseCase.execute(currentQuestion, _controller.text);

    setState(() {
      result = isCorrect ? "👍 正解！" : "❌ もう一度";
    });
  }

  Future<void> playSound() async {
    await _flipKey.currentState?.playCurrentSound();
  }

  Future<void> nextQuestion() async {
    final index = ref.read(currentIndexProvider);

    if (index >= questions.length - 1) return;

    _flipKey.currentState?.reset();
    ref.read(currentIndexProvider.notifier).state = index + 1;
    ref.read(isFrontProvider.notifier).state = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _flipKey.currentState?.playCurrentSound();
    });
    // setState(() {
    //   isFront = true;
    //   currentIndex = (currentIndex + 1) % questions.length;
    //   result = "";
    //   _controller.clear();
    // });

    // 👇 UI更新後に必ず再生
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _flipKey.currentState?.playCurrentSound();
    // });
  }

  Future<void> prevQuestion() async {
    final index = ref.read(currentIndexProvider);
    final state = ref.watch(trainingProvider);
    if (index < 1) return;

    _flipKey.currentState?.reset();

    ref.read(currentIndexProvider.notifier).state = index - 1;
    ref.read(isFrontProvider.notifier).state = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _flipKey.currentState?.playCurrentSound();
    });
    // if (currentIndex < 1) return;

    // _flipKey.currentState?.reset();

    // setState(() {
    //   isFront = true;
    //   currentIndex = (currentIndex - 1) % questions.length;
    //   result = "";
    //   _controller.clear();
    // });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _flipKey.currentState?.playCurrentSound();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final isFront = ref.watch(isFrontProvider);
    final currentIndex = ref.watch(currentIndexProvider);
    // 👇 これが超重要（ガード）
    if (isLoading || questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('FlashEnglish')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("トレーニングモード : ${widget.mode}"),
            Text("問題 ${currentIndex + 1}/${questions.length}"),
            ElevatedButton(
              onPressed: nextQuestion,
              child: const Text("次へ"),
            ),
            const SizedBox(height: 20),
            FlashCardWidget(
              key: ValueKey(currentIndex),
              frontText: currentQuestion.japanese,
              backText: currentQuestion.english,
              frontAudio: currentQuestion.japaneseAudio,
              backAudio: currentQuestion.englishAudio,
              onFlip: (front) {
                ref.read(isFrontProvider.notifier).state = front;
              },
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton.filled(
                icon: const Icon(Icons.fast_rewind),
                color: Colors.white,
                onPressed: prevQuestion,
              ),
              const SizedBox(width: 20),
              if (!isFront) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('不正解'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
              const SizedBox(width: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.campaign),
                label: const Text('もう一度再生'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: playSound,
              ),
              const SizedBox(width: 20),
              if (!isFront) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('正解'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
              const SizedBox(width: 20),
              IconButton.filled(
                icon: const Icon(Icons.fast_forward),
                color: Colors.white,
                onPressed: nextQuestion,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
