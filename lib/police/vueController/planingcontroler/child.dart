import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../helper/serveur/authentificateur.dart';



class CustomTableCalendar extends StatefulWidget {
  @override
  _CustomTableCalendarState createState() => _CustomTableCalendarState();
}

class _CustomTableCalendarState extends State<CustomTableCalendar>  with TickerProviderStateMixin {
  late final ValueNotifier<List<Event>> _events;
  late AnimationController _animationController;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _events = ValueNotifier(_getEventsForDay(DateTime.now()) as List<Event>);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _events.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<List<Object?>> _getEventsForDay(DateTime day) async {
    try {
      final events = await AuthApi.getPlanningData();
      return events?.map((planning) {
        return Event(
          date: DateTime.parse(planning.datePres),
          title: planning.description,
          color: _getColorFromHex(planning.eventColor),
          cancelable: planning.btnCancel,
        );
      }).toList() ?? [];
    } catch (e) {
      // Handle the error (e.g., show an error message)
      print('Error fetching planning data: $e');
      return [];
    }
  }


  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor; // 8 char with opacity
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      rangeSelectionMode: _rangeSelectionMode,
      eventLoader: _getEventsForDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        // Use `CalendarStyle` to customize the UI
        outsideDaysVisible: false,
      ),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _rangeStart = null; // Important to clean those
            _rangeEnd = null;
            _rangeSelectionMode = RangeSelectionMode.toggledOff;
          });

          _events.value = _getEventsForDay(selectedDay);
        }
      },
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          _selectedDay = null;
          _focusedDay = focusedDay;
          _rangeStart = start;
          _rangeEnd = end;
          _rangeSelectionMode = RangeSelectionMode.toggledOn;
        });
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() => _calendarFormat = format);
        }
      },
      onDayLongPressed: (selectedDay) {
        setState(() {
          _selectedDay = null;
          _focusedDay = selectedDay;
          _rangeStart = null;
          _rangeEnd = null;
          _rangeSelectionMode = RangeSelectionMode.toggledOff;
        });
      },
      onHeaderTapped: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          return events.map((event) {
            if (event.cancelable) {
              return Positioned(
                right: 1,
                top: 1,
                child: Icon(
                  Icons.close,
                  size: 12.0,
                  color: Colors.red,
                ),
              );
            }
          }).toList();
        },
        selectedBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _calendarStyle.selectedColor,
              ),
              width: 100,
              height: 100,
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: TextStyle().copyWith(color: Colors.white),
                ),
              ),
            ),
          );
        },
        todayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(6.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.amber[500],
              shape: BoxShape.circle,
            ),
            width: 100,
            height: 100,
            child: Text(
              date.day.toString(),
              style: TextStyle().copyWith(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}

class Event {
  final DateTime date;
  final String title;
  final Color color;
  final bool cancelable;

  const Event({
    required this.date,
    required this.title,
    required this.color,
    required this.cancelable,
  });
}
