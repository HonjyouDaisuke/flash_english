import 'package:flash_english/presentation/providers/study_log/get_study_days_usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studyDaysProvider = FutureProvider.family<Map<DateTime, bool>, DateTime>(
    (ref, focusedDay) async {
  final useCase = ref.read(getStudyDaysUseCaseProvider);

  final startDate = DateTime(focusedDay.year, focusedDay.month, 1);

  final endDate = DateTime(
    focusedDay.year,
    focusedDay.month + 1,
    0,
  );

  return useCase.execute(startDate, endDate);
});
