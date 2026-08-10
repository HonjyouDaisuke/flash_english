abstract class StudyRepository {
  Future<int> startSession();
  Future<void> endSession(int sessionId);
  Future<void> saveAnswer({
    required String id,
    required int questionId,
    required bool isCorrect,
    required int sessionId,
    required int categoryNo,
    required int unitNo,
    required int questionNo,
    required int durationSeconds,
  });
}
