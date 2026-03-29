import 'package:flash_english/domain/entities/daily_stats.dart';
import 'package:flash_english/domain/entities/study_log.dart';
import 'package:flash_english/domain/repositories/study_log_repository.dart';
import 'package:flash_english/domain/repositories/study_session_repository.dart';

class GetTodayStatsUseCase {
  final StudyLogRepository logRepository;
  final StudySessionRepository sessionRepository;

  GetTodayStatsUseCase(
    this.logRepository,
    this.sessionRepository,
  );

  List<StudyLog> _filterByDate(List<StudyLog> logs, DateTime date) {
    return logs.where((l) {
      return l.createdAt.year == date.year &&
          l.createdAt.month == date.month &&
          l.createdAt.day == date.day;
    }).toList();
  }

  Future<DailyStats> execute() async {
    final now = DateTime.now();
    final logs = await logRepository.getAllLogs();
    final todayLogs = _filterByDate(logs, now);

    final sessions = await sessionRepository.getSessionsByDate(now);

    final totalTime = sessions.fold<Duration>(
      Duration.zero,
      (sum, s) => sum + s.duration,
    );

    final total = todayLogs.length;
    final correct = todayLogs.where((l) => l.isCorrect).length;

    return DailyStats(
      studyTime: totalTime,
      sentenceCount: total,
      correctCount: correct,
      wrongCount: total - correct,
    );
  }
}
