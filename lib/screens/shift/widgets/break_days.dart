import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/provider/shift_config_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class IntervalDatePicker extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  IntervalDatePicker({required this.startDate, required this.endDate});

  @override
  _IntervalDatePickerState createState() => _IntervalDatePickerState();
}

class _IntervalDatePickerState extends State<IntervalDatePicker> {
  late Map<DateTime, bool> _intervalDates;

  @override
  void initState() {
    super.initState();
    _initializeIntervalDates();
  }

  void _initializeIntervalDates() {
    _intervalDates = {};
    DateTime currentDate = widget.startDate;

    while (currentDate.isBefore(widget.endDate) ||
        currentDate.isAtSameMomentAs(widget.endDate)) {
      _intervalDates[
              DateTime(currentDate.year, currentDate.month, currentDate.day)] =
          false;
      currentDate = currentDate.add(Duration(days: 1));
    }
  }

  bool _isInInterval(DateTime date) {
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    return _intervalDates.containsKey(normalizedDate);
  }

  bool _isSelected(DateTime date) {
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    var sp = context.read<ShiftProvider>();
    return sp.breakingDays.contains(normalizedDate);
  }

  void _onDateSelected(DateTime date, DateTime? _) {
    var provider = context.read<ShiftProvider>();
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    if (_isInInterval(normalizedDate)) {
      setState(() {
        provider.setBreakDays(normalizedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.now(),
          lastDay: widget.endDate.add(Duration(days: 120)),
          focusedDay: DateTime.now(),
          selectedDayPredicate: (day) {
            DateTime normalizedDay = DateTime(day.year, day.month, day.day);
            return _isSelected(normalizedDay);
          },
          calendarStyle: CalendarStyle(
            defaultDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            selectedDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
          ),
          onDaySelected: _onDateSelected,
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              DateTime normalizedDay = DateTime(day.year, day.month, day.day);
              if (_isInInterval(normalizedDay)) {
                return Container(
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isSelected(normalizedDay)
                        ? Colors.blue
                        : Colors.green.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Text(
                      "${day.day}",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
