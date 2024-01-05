import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../acteurs/disponibilites.dart';
import '../../helper/serveur/authentificateur.dart';

class DisponibiliteScreen extends StatefulWidget {
  const DisponibiliteScreen({Key? key}) : super(key: key);

  @override
  _DisponibiliteScreenState createState() => _DisponibiliteScreenState();
}

class _DisponibiliteScreenState extends State<DisponibiliteScreen> {
  bool isMorningSelected = false;
  bool isEveningSelected = false;
  TimeOfDay _startMorning = TimeOfDay.now();
  TimeOfDay _endMorning = TimeOfDay.now();
  TimeOfDay _startEvening = TimeOfDay.now();
  TimeOfDay _endEvening = TimeOfDay.now();
  DateTime? _selectedStartDay;
  DateTime? _selectedEndDay;
  Set<DateTime> _selectedDates = {};
  Map<String, Disponibilite> allAvailabilities = {};

  DateTime? _lastSelectedDate;
  DateTime _lastTapTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchAllAvailabilities();
    // Set initial times to the nearest hour with 0 minutes
    TimeOfDay now = TimeOfDay.now();
    _startMorning = TimeOfDay(hour: 8, minute: 0);
    _endMorning = TimeOfDay(hour: 13, minute: 0);
    _startEvening = TimeOfDay(hour: 13, minute: 0);
    _endEvening = TimeOfDay(hour: 18, minute: 0);
  }


  Future<void> _fetchAllAvailabilities() async {
    List<Disponibilite>? availabilities = await AuthApi.getDisponibilites();
    setState(() {
      for (var availability in availabilities ?? []) {
        allAvailabilities[availability.date] = availability;
      }
    });
  }

  Future<void> _handleDaySelected(DateTime day, DateTime focusedDay) async {
    final now = DateTime.now();
    if (_lastSelectedDate != null &&
        day == _lastSelectedDate &&
        now.difference(_lastTapTime) < Duration(milliseconds: 300)) {
      _selectedStartDay = day;
      _selectedEndDay = day;
      _selectedDates = {day};
      _showAvailabilityDetails();
    } else {
      if (_selectedStartDay == null || _selectedEndDay != null ||
          day.isBefore(_selectedStartDay!) ||
          day.difference(_selectedStartDay!).inDays > 30) {
        _selectedStartDay = day;
        _selectedEndDay = null;
        _selectedDates = {day};
        if (day.difference(_selectedStartDay!).inDays > 30) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("La plage de dates ne peut pas dépasser un mois."),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else if (_selectedStartDay != null && _selectedEndDay == null &&
          day.isAfter(_selectedStartDay!)) {
        _selectedEndDay = day;
        _selectedDates = _daysInRange().toSet();
      }
    }
    _lastSelectedDate = day;
    _lastTapTime = now;
    setState(() {});
  }

  List<DateTime> _daysInRange() {
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

  Future<void> _showAvailabilityDetails() async {
    if (_selectedStartDay == null) {
      return;
    }
    String selectedDateString = DateFormat('yyyy-MM-dd').format(_selectedStartDay!);
    Disponibilite? availability = allAvailabilities[selectedDateString];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Disponibilités pour $selectedDateString'),
          content: availability != null
              ? SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  title: Text("Disponibilité"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Matin: ${availability.heureDebutMatin} - ${availability.heureFinMatin}"),
                      Text("Soir: ${availability.heureDebutSoir} - ${availability.heureFinSoir}"),
                    ],
                  ),
                )
              ],
            ),
          )
              : Text('Aucune disponibilité trouvée pour cette date.'),
          actions: <Widget>[
            TextButton(
              child: Text("Fermer"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Text(
                "Choisir une plage de dates et indiquer la disponibilité.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            Container(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2023, 1, 1),
                        lastDay: DateTime.utc(2029, 12, 31),
                        focusedDay: _selectedStartDay ?? DateTime.now(),
                        selectedDayPredicate: (day) => _selectedDates.contains(day),
                        onDaySelected: _handleDaySelected,
                        eventLoader: (day) {
                          String dateString = DateFormat('yyyy-MM-dd').format(day);
                          return allAvailabilities.containsKey(dateString) ? [allAvailabilities[dateString]] : [];
                        },
                      ),
                    ),
                    SizedBox(height: 15.0),
                    ElevatedButton(
                      onPressed: _openForm,
                      child: const Text('Renseigner les disponibilités'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }

  void _openForm() async {
    if (_selectedDates.isNotEmpty) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Wrap(
                children: <Widget>[
                  _buildToggle("Matinée", isMorningSelected, 'morning'),
                  _buildToggle("Soirée", isEveningSelected, 'evening'),
                  _buildTimePicker("Heure début matinée", 'startMorning'),
                  _buildTimePicker("Heure fin matinée", 'endMorning'),
                  _buildTimePicker("Heure début soirée", 'startEvening'),
                  _buildTimePicker("Heure fin soirée", 'endEvening'),
                  ElevatedButton(
                      child: Text('Enregistrer les disponibilités'),
                      onPressed: () {
                        List<Map<String, dynamic>> disponibilites = _selectedDates.map((date) {
                          return {
                            'date': DateFormat('yyyy-MM-dd').format(date),
                            'heure_debutMatin': _formatTimeOfDay(_startMorning),
                            'heure_finMatin': _formatTimeOfDay(_endMorning),
                            'heure_debutSoir': _formatTimeOfDay(_startEvening),
                            'heure_finSoir': _formatTimeOfDay(_endEvening),
                          };
                        }).toList();
                        sendDisponibilites(disponibilites);
                        Navigator.pop(context);
                      })
                ],
              ),
            );
          });
    }
  }
  Future<void> sendDisponibilites(List<Map<String, dynamic>> disponibilites) async {
    try {
      var tokenVar = await SharedPreferences.getInstance().then((prefs) {
        return prefs.getString('token');
      });

      if (tokenVar == null) {
        return;
      }

      const url = 'https://appariteur.com/api/users/disponibilites.php';
      final Map<String, dynamic> requestBody = {'updates': disponibilites};

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenVar',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Succès'),
              content: const Text('Disponibilités renseignées avec succès'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erreur'),
              content: const Text('Une erreur est survenue, veuillez réessayer plus tard'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: Text('Une erreur est survenue: $e'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
  Widget _buildToggle(String title, bool isSelected, String identifier) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: isSelected,
        onChanged: (value) {
          setState(() {
            if (identifier == 'morning') {
              isMorningSelected = value;
              if (value) {
                _startMorning = TimeOfDay(hour: 0, minute: 0);
                _endMorning = TimeOfDay(hour: 0, minute: 0);
              }
            } else {
              isEveningSelected = value;
              if (value) {
                _startEvening = TimeOfDay(hour: 0, minute: 0);
                _endEvening = TimeOfDay(hour: 0, minute: 0);
              }
            }
          });
        },
      ),
    );
  }

  Widget _buildTimePicker(String label, String identifier) {
    return ListTile(
      title: Text(label),
      trailing: DropdownButton<TimeOfDay>(
        value: _getTime(identifier),
        onChanged: (TimeOfDay? newValue) {
          setState(() {
            _setTime(identifier, newValue!);
          });
        },
        items: List.generate(24, (index) {
          return DropdownMenuItem<TimeOfDay>(
            value: TimeOfDay(hour: index, minute: 0),
            child: Text('${index.toString().padLeft(2, '0')}:00'),
          );
        }),
      ),
    );
  }
  void _setTime(String identifier, TimeOfDay time) {
    setState(() {
      if (identifier == 'startMorning') {
        _startMorning = time;
      } else if (identifier == 'endMorning') {
        _endMorning = time;
      } else if (identifier == 'startEvening') {
        _startEvening = time;
      } else if (identifier == 'endEvening') {
        _endEvening = time;
      }
    });
  }

  TimeOfDay _getTime(String identifier) {
    switch (identifier) {
      case 'startMorning':
        return _startMorning;
      case 'endMorning':
        return _endMorning;
      case 'startEvening':
        return _startEvening;
      case 'endEvening':
        return _endEvening;
      default:
        return TimeOfDay.now();
    }
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); // Converts DateTime object to a string in the desired format
    return format.format(dt);
  }
}
