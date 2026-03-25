import 'package:flash_english/application/usecases/check_answer_usecase.dart';
import 'package:flash_english/application/usecases/get_questions_usecase.dart';
import 'package:flash_english/domain/entities/question.dart';
import 'package:flash_english/infrastructure/datasources/local/question_local_data_source.dart';
import 'package:flash_english/infrastructure/repositories/question_repository_impl.dart';
import 'package:flash_english/presentation/widgets/flash_card_widget.dart';
import 'package:flutter/material.dart';

class ShuffleTrainingPage extends StatefulWidget {
  const ShuffleTrainingPage({super.key});

  @override
  State<ShuffleTrainingPage> createState() => _ShuffleTrainingPageState();
}

class _ShuffleTrainingPageState extends State<ShuffleTrainingPage> {
  final TextEditingController _controller = TextEditingController();
  final _checkAnswerUseCase = CheckAnswerUseCase();
  late final GetQuestionsUseCase _getQuestionsUseCase;
  final GlobalKey<FlashCardWidgetState> _flipKey = GlobalKey();
  int currentIndex = 0;
  String result = "";

  List<Question> questions = [];
  bool isLoading = true;

  Question get currentQuestion => questions[currentIndex];

  @override
  void initState() {
    super.initState();

    final dataSource = QuestionLocalDataSource();
    final repository = QuestionRepositoryImpl(dataSource);
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

  Future<void> nextQuestion() async {
    _flipKey.currentState?.reset();

    setState(() {
      currentIndex = (currentIndex + 1) % questions.length;
      result = "";
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("問題 ${currentIndex + 1}/${questions.length}"),
            const SizedBox(height: 10),
            Text(
              currentQuestion.japanese,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "英語で入力",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkAnswer,
              child: const Text("判定"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: nextQuestion,
              child: const Text("次へ"),
            ),
            const SizedBox(height: 20),
            Text(result),
            FlashCardWidget(
              key: ValueKey(currentIndex),
              frontText: currentQuestion.japanese,
              backText: currentQuestion.english,
              frontAudio: currentQuestion.japaneseAudio,
              backAudio: currentQuestion.englishAudio,
            ),
          ],
        ),
      ),
    );
  }
}
