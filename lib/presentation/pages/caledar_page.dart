import 'package:flash_english/presentation/providers/calendar/study_days_provider.dart';
import 'package:flash_english/presentation/providers/study_log/today_stats_provider.dart';
import 'package:flash_english/presentation/widgets/study_calendar.dart';
import 'package:flash_english/presentation/widgets/today_stats_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double uiHeight = MediaQuery.of(context).size.height;
    double uiWidth = MediaQuery.of(context).size.width;
    final studyStatusAsync = ref.watch(
      studyDaysProvider(_focusedDay),
    );
    final todayStatsAsync = ref.watch(todayStatsProvider(_selectedDay));
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "学習記録カレンダー",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(
            height: uiHeight * 0.05,
          ),
          Center(
            child: SizedBox(
              width: uiWidth * 0.9,
              height: uiHeight * 0.5,
              child: studyStatusAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => Center(
                  child: Text(e.toString()),
                ),
                data: (studyStatus) {
                  return StudyCalendar(
                    studyStatus: studyStatus,
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: uiHeight * 0.045,
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: uiWidth * 0.5,
                child: todayStatsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, _) => Center(
                    child: Text(e.toString()),
                  ),
                  data: (stats) => TodayStatsCardWidget(
                    stats: stats,
                    date: _selectedDay,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
