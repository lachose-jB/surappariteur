import 'package:flutter/material.dart';
import 'package:surappariteur/police/vueController/home/child.dart';
import 'package:surappariteur/vue/mission/missionvue.dart';

import '../../addonglobal/topbar.dart';
import '../../police/acteurs/userinfo.dart';
import '../../police/vueController/contratController/contratChild.dart';
import '../notif/notifScreen.dart';

class ContratVue extends StatelessWidget {
  static String routeName = "/home";
  const ContratVue({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TopBarS(
        onNotificationPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NotifScreen()));
        },
        PageName: "Contrats", // Pass the page name here
      ),
      backgroundColor: Colors.grey,
      body: ContratChild(),
      //bottomNavigationBar: MyBottomBar(),
    );
  }
}
