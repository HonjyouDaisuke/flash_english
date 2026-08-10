import 'package:flash_english/domain/repositories/study_log_repository.dart';
import 'package:flash_english/domain/repositories/study_session_repository.dart';

class GetStudyDaysUseCase {
  final StudyLogRepository logRepository;
  final StudySessionRepository sessionRepository;

  GetStudyDaysUseCase(
    this.logRepository,
    this.sessionRepository,
  );

  Future<Map<DateTime, bool>> execute(
    DateTime startDate,
    DateTime endDate,
  ) async {
    // 指定期間のStudyLogを取得
    final logs = await logRepository.getByPeriod(startDate, endDate);

    // 学習した日だけSetに入れる
    final studiedDays = logs
        .map((e) => DateTime(
              e.createdAt.year,
              e.createdAt.month,
              e.createdAt.day,
            ))
        .toSet();

    final result = <DateTime, bool>{};
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    var day = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );

    final last = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    );

    while (!day.isAfter(last)) {
      if (day.isAfter(today)) {
        day = day.add(const Duration(days: 1));
        continue;
      }

      result[day] = studiedDays.contains(day);

      day = day.add(const Duration(days: 1));
    }
    return result;
  }
}
