import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../helper/serveur/authentificateur.dart';

class HomeChild extends StatefulWidget {
  const HomeChild({Key? key}) : super(key: key);
  @override
  State<HomeChild> createState() => _HomeChildState();
}

class _HomeChildState extends State<HomeChild> {
  DateTime _selectedDay = DateTime.now();
  var heure_Year = "";
  var heure_Month = "";
  var heure_Week = "";

  Future<void> ShowUserInfo() async {
    final userInfo = await AuthApi.InfoUser();
    if (userInfo != null) {
      heure_Year = userInfo.heureYear ?? '00:00:00';
      heure_Month = userInfo.heureMonth ?? '00:00:00';
      heure_Week = userInfo.heureWeek ?? '00:00:00';
      print(heure_Year);
      print(heure_Month);
      print(heure_Week);
    } else {
      // Gérer la connexion échouée ici
    }
  }

  DateTime selectedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    ShowUserInfo();
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Text(
                    "Nombres d'heures de prestation",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/mission.png",
                        height: 50,
                      ),
                      Container(
                        width: 140.0, // Ajoutez la largeur fixe de 60
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.redAccent,
                                offset: Offset(0, 2),
                                blurRadius: 6.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                heure_Week,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              const Text(
                                "Cette semaine",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/mission.png",
                        height: 50,
                      ),
                      Container(
                        width: 140.0, // Ajoutez la largeur fixe de 60
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.redAccent,
                                offset: Offset(0, 2),
                                blurRadius: 6.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                heure_Month,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              const Text(
                                "Ce mois",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/mission.png",
                        height: 50,
                      ),
                      Container(
                        width: 140.0, // Ajoutez la largeur fixe de 60
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.redAccent,
                                offset: Offset(0, 2),
                                blurRadius: 6.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                heure_Year,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              const Text(
                                "Cette année",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                  },
                  locale: 'fr', // Utilisation de la localisation française
                ),
              ),
              const SizedBox(height: 30.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Text(
                  "Planning des disponibilités",
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
                  calendarFormat: calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                  },
                  locale: 'fr',
                ),
              ),
              // Autres éléments à ajouter à votre SingleChildScrollView
            ],
          ),
        ),
      ),
    );
  }
}