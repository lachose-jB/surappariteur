import 'package:flutter/material.dart';

import '../../addonglobal/topbar.dart';
import '../../police/vueController/missioncontroler/childmission.dart';
import '../../police/vueController/missioncontroler/newMission.dart';
import '../notif/notifScreen.dart';

class MissionScreen extends StatelessWidget {
  static String routeName = "/mission";
  const MissionScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBarS(
        onNotificationPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NotifScreen()));
        },
        PageName: "Profile", // Pass the page name here
      ),
      backgroundColor: Colors.grey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MissionNew()),
          ); // Action à effectuer lorsque le bouton est cliqué
        },
        child: const Icon(Icons.add),
      ),
      body: BodyM(),
    );
  }
}
