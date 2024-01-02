import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

import '../../acteurs/planning.dart';
import '../../helper/serveur/authentificateur.dart';

class CustomTableCalendar extends StatefulWidget {
  @override
  _CustomTableCalendarState createState() => _CustomTableCalendarState();
}

class _CustomTableCalendarState extends State<CustomTableCalendar> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Planning>? _planningData;

  @override
  void initState() {
    super.initState();
    _fetchPlanningData();
  }

  void _fetchPlanningData() async {
    _planningData = await AuthApi.getPlanningData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      calendarFormat: _calendarFormat,
      eventLoader: _getEventsForDay,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            if ((events[0] as Planning).btnCancel) {
              return Positioned(
                right: 1,
                top: 1,
                child: Icon(
                  Icons.close,
                  size: 12.0,
                  color: Colors.grey,
                ),
              );
            }
          }
          return null;
        },
        selectedBuilder: (context, date, events) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: _planningData![date.day - 1].btnCancel
                    ? Colors.green[400]
                    : Colors.grey[400],
                shape: BoxShape.circle
            ),
          );
        },
      ),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
  List<Planning> _getEventsForDay(DateTime day) {
    return _planningData!.where((planning) {
      return isSameDay(day, DateTime.parse(planning.datePres));
    }).toList();
  }
}