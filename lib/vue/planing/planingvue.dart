import 'package:flutter/material.dart';
import 'package:surappariteur/addonglobal/topbar.dart';

import '../../police/vueController/planingcontroler/child.dart';
import '../../police/vueController/planingcontroler/newPlaning.dart';
import '../notif/notifScreen.dart';

class PlanningScreen extends StatelessWidget {
  static String routeName = "/planning";

  PlanningScreen({Key? key}) : super(key: key);
  // Replace with your actual notification count

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBarS(
        onNotificationPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NotifScreen()));
        },
        PageName: "Accueil", // Pass the page name here
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PlaningNew()));
        },
        child: const Icon(Icons.add),
      ),
      body:  CalendarPage (),
    );
  }
}
