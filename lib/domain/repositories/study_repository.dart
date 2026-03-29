abstract class StudyRepository {
  Future<int> startSession();
  Future<void> endSession(int sessionId);
  Future<void> saveAnswer({
    required int questionId,
    required bool isCorrect,
    required int sessionId,
  });
}
