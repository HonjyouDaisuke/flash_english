import 'package:flash_english/domain/entities/daily_stats.dart';
import 'package:flash_english/presentation/providers/study_log/get_today_stats_usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todayStatsProvider =
    FutureProvider.family<DailyStats, DateTime>((ref, date) async {
  final useCase = ref.read(getTodayStatsUseCaseProvider);
  return useCase.execute(date: date);
});
