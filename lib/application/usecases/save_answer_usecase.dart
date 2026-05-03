import 'package:flash_english/domain/repositories/study_repository.dart';

class SaveAnswerUseCase {
  final StudyRepository repository;

  SaveAnswerUseCase(this.repository);

  Future<void> execute({
    required int questionNo,
    required bool isCorrect,
    required int sessionId,
  }) {
    return repository.saveAnswer(
      questionId: questionNo,
      isCorrect: isCorrect,
      sessionId: sessionId,
    );
  }
}
