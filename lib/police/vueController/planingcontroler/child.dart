import 'package:flutter/material.dart';
import 'package:surappariteur/police/acteurs/planning.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../helper/serveur/authentificateur.dart';
import '../missioncontroler/missionListScreen.dart';


class PlanningShield extends StatefulWidget {
  const PlanningShield({Key? key}) : super(key: key);

  @override
  _PlanningShieldState createState() => _PlanningShieldState();
}

class _PlanningShieldState extends State<PlanningShield> {
  DateTime _selectedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.week;
  Map<DateTime, List<Planning>> _events = {};

  Future<void> _handleDaySelected(DateTime day, DateTime focusedDay) async {
    final String dateDebuts = '${day.year}-${day.month}-${day.day}';
    final String dateFins = '${day.year}-${day.month}-${day.day}';

    try {
      final planningData = await AuthApi.fetchPlanningData();

      setState(() {
        _events[day] = planningData;
        _selectedDay = day;
      });
    } catch (e) {
      print('Erreur lors de la récupération des données de planification : $e');
    }

    // Ajoutez ici votre logique supplémentaire pour la gestion de la sélection de la journée
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Text(
              "Planning des missions du mois",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ),
          const SizedBox(height: 30.0),
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
            child: TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2029, 12, 31),
              focusedDay: _selectedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (day, focusedDay) {
                _handleDaySelected(day, focusedDay);
              },
              eventLoader: (day) {
                return _events[day] ?? [];
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
                            color: Color(int.parse('0xFF${event.eventColor}')),
                          ),
                        ),
                      ),
                    );
                  }
                  return markers;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
