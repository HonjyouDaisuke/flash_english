import 'package:flash_english/domain/entities/question.dart';

class DailyStats {
  final Duration studyTime;
  final int sentenceCount;
  final int correctCount;
  final int wrongCount;
  final List<Question> wrongQuestions;

  DailyStats({
    required this.studyTime,
    required this.sentenceCount,
    required this.correctCount,
    required this.wrongCount,
    required this.wrongQuestions,
  });
}
