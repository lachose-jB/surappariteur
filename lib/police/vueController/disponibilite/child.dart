import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../acteurs/planning.dart';
import '../../helper/serveur/authentificateur.dart';

class DisponibiliteScreen extends StatefulWidget {
  const DisponibiliteScreen({Key? key}) : super(key: key);

  @override
  _DisponibliteScreenState createState() => _DisponibliteScreenState();
}

class _DisponibliteScreenState extends State<DisponibiliteScreen> {
  DateTime? _selectedStartDay;
  DateTime? _selectedEndDay;
  CalendarFormat calendarFormat = CalendarFormat.week;
  Map<DateTime, List<Planning>> _events = {};
  Set<DateTime> _selectedDates = {};

  Future<void> _handleDaySelected(DateTime day, DateTime focusedDay) async {
    setState(() {
      if (_selectedStartDay == null || _selectedEndDay != null) {
        // Start a new range
        _selectedStartDay = day;
        _selectedEndDay = null;
        _selectedDates = {day};
      } else {
        // Complete the range
        _selectedEndDay = day;
        _selectedDates = _daysInRange().toSet();
      }
    });
    await _fetchPlanningData();
  }

  Future<void> _fetchPlanningData() async {
    if (_selectedStartDay != null && _selectedEndDay != null) {
      // Fetch planning data for each selected date individually
      for (DateTime day in _daysInRange()) {
        await _fetchPlanningDataForDate(day);
      }
    }
  }

  Future<void> _fetchPlanningDataForDate(DateTime date) async {
    try {
      final String formattedDate =
          '${date.year}-${date.month}-${date.day}';

      final planningData =
      await AuthApi.getPlanningData();

      setState(() {
        _events[date] = planningData!;
      });
    } catch (e) {
      print('Error fetching planning data for $date: $e');
    }
  }

  List<DateTime> _daysInRange() {
    // Return a list of days in the selected range
    List<DateTime> daysInRange = [];
    if (_selectedStartDay != null && _selectedEndDay != null) {
      for (DateTime day = _selectedStartDay!;
      day.isBefore(_selectedEndDay!.add(Duration(days: 1)));
      day = day.add(Duration(days: 1))) {
        daysInRange.add(day);
      }
    }
    return daysInRange;
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFF31393C),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Text(
              "Vous pouvez choisir une plage de dates pour indiquer votre disponibilité.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 5),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: GestureDetector(
              onLongPress: () {
                // Handle long press here
                print("Long press detected!");
              },
              child: TableCalendar(
                firstDay: DateTime.utc(2023, 1, 1),
                lastDay: DateTime.utc(2029, 12, 31),
                focusedDay: _selectedStartDay ?? DateTime.now(),
                selectedDayPredicate: (day) {
                  return _selectedDates.contains(day);
                },
                onDaySelected: (day, focusedDay) {
                  _handleDaySelected(day, focusedDay);
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    final List<Widget> markers = [];
                    for (var event in events) {
                      markers.add(
                        Positioned(
                          top: 1,
                          child: Container(
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }
                    return markers.isNotEmpty ? Column(children: markers) : null;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
