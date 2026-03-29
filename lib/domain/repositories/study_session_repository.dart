import 'package:flash_english/domain/entities/study_session.dart';

abstract class StudySessionRepository {
  Future<List<StudySession>> getSessionsByDate(DateTime date);
}
