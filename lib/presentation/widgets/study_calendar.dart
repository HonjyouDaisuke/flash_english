import 'package:flash_english/presentation/widgets/study_calendar_builders.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class StudyCalendar extends StatelessWidget {
  StudyCalendar({
    super.key,
    required this.studyStatus,
    required this.focusedDay,
    required this.selectedDay,
    this.onPageChanged,
    this.onDaySelected,
  });

  final Map<DateTime, bool> studyStatus;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final builders = StudyCalendarBuilders();

  final ValueChanged<DateTime>? onPageChanged;
  final void Function(DateTime selectedDay, DateTime focusedDay)? onDaySelected;

  static final DateTime _firstDay = DateTime.utc(2024, 1, 1);
  static final DateTime _lastDay = DateTime.utc(2050, 12, 31);

  DateTime _clampFocusedDay(DateTime day) {
    if (day.isBefore(_firstDay)) {
      return _firstDay;
    }

    if (day.isAfter(_lastDay)) {
      return _lastDay;
    }

    return day;
  }

  @override
  Widget build(BuildContext context) {
    final calendarFocusedDay = _clampFocusedDay(focusedDay);
    return TableCalendar(
      rowHeight: 42,
      daysOfWeekHeight: 30,
      sixWeekMonthsEnforced: true,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
      ),
      eventLoader: (day) {
        final status = studyStatus[DateUtils.dateOnly(day)];

        if (status == null) {
          return ['none'];
        }

        return status ? ['done'] : ['miss'];
      },
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2050, 12, 31),
      focusedDay: calendarFocusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(day, selectedDay);
      },
      onPageChanged: onPageChanged,
      onDaySelected: onDaySelected,
      calendarBuilders: builders.build(),
    );
  }
}
