import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../helper/serveur/authentificateur.dart';

class HomeChild extends StatefulWidget {
  const HomeChild({Key? key}) : super(key: key);
  @override
  State<HomeChild> createState() => _HomeChildState();
}

class _HomeChildState extends State<HomeChild> {
  var heure_Year = "";
  var heure_Month = "";
  var heure_Week = "";

  @override
  void initState() {
    super.initState();
    ShowUserInfo();
  }

  Future<void> ShowUserInfo() async {
    final userInfo = await AuthApi.InfoUser();
    if (userInfo != null) {
      setState(() {
        heure_Year = userInfo.heureYear ?? '00:00:00';
        heure_Month = userInfo.heureMonth ?? '00:00:00';
        heure_Week = userInfo.heureWeek ?? '00:00:00';
        print(heure_Year);
        print(heure_Month);
        print(heure_Week);
      });
    } else {
      // Gérer la connexion échouée ici
    }
  }


  @override
  Widget build(BuildContext context) {
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


            ],
          ),
        ),
      ),
    );
  }
}

