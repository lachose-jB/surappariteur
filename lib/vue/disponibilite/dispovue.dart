import 'package:flutter/material.dart';
import 'package:surappariteur/addonglobal/topbar.dart';
import 'package:surappariteur/police/vueController/disponibilite/child.dart';

import '../notif/notifScreen.dart';

class DispoScreen extends StatelessWidget {
  static String routeName = "/dispo";

  DispoScreen({Key? key}) : super(key: key);
  // Replace with your actual notification count

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBarS(
        onNotificationPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NotifScreen()));
        },
        PageName: "Mes Disponibilités", // Pass the page name here
      ),
      backgroundColor: Colors.white,
      body:  const DisponibiliteScreen (),
    );
  }
}
