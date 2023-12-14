import 'package:flutter/material.dart';
import 'package:surappariteur/police/vueController/fichepaieController/fichePaieChild.dart';

import '../../addonglobal/topbar.dart';
import '../../police/vueController/profile/child.dart';
import '../notif/notifScreen.dart';

class FicheVue extends StatelessWidget {
  static String routeName = "/fiche";

  const FicheVue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBarS(
        onNotificationPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NotifScreen()));
        },
        PageName: "Fiches de Paie", // Pass the page name here
      ),
      backgroundColor: Colors.blueAccent,
      body: FichesPaieChild(),
    );
  }
}
