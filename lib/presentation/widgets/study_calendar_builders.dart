import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class StudyCalendarBuilders {
  CalendarBuilders build() {
    return CalendarBuilders(
      defaultBuilder: defaultBuilder,
      disabledBuilder: disabledBuilder,
      selectedBuilder: selectedBuilder,
      markerBuilder: markerBuilder,
      outsideBuilder: outsideBuilder,
      todayBuilder: todayBuilder,
    );
  }

  Widget _cell({
    required BuildContext context,
    required DateTime day,
    Color? textColor,
    Color? borderColor,
    double borderWidth = 0.1,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colors.blue,
          width: borderWidth,
        ),
      ),
      alignment: Alignment.topCenter,
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: textColor ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget defaultBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
  ) =>
      _cell(context: context, day: day);

  Widget disabledBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
  ) =>
      _cell(context: context, day: day, textColor: Colors.grey);

  Widget selectedBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
  ) =>
      _cell(
        context: context,
        day: day,
        borderColor: Colors.red,
        borderWidth: 3,
      );

  Widget todayBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
  ) =>
      _cell(
        context: context,
        day: day,
        textColor: Colors.red,
      );

  Widget? markerBuilder(
    BuildContext context,
    DateTime day,
    List<dynamic> events,
  ) {
    if (events.isEmpty) {
      return null;
    }

    final status = events.first;

    String text;
    Color color;

    switch (status) {
      case 'done':
        text = '●';
        color = Colors.green;
        break;

      case 'miss':
        text = '×';
        color = Colors.red;
        break;

      default:
        text = '-';
        color = Colors.grey;
    }

    return Positioned(
      bottom: 2,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget outsideBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
  ) =>
      _cell(
        context: context,
        day: day,
        textColor: Colors.grey,
      );
}
