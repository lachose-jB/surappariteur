import 'package:flutter/material.dart';
import 'package:surappariteur/police/vueController/home/child.dart';

import '../../addonglobal/topbar.dart';
import '../../police/acteurs/userinfo.dart';
import '../notif/notifScreen.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final UserInfo userInfo;
    return Scaffold(
      appBar: TopBarS(
        onNotificationPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NotifScreen()));
        },
        PageName: "Mon Récap", // Pass the page name here
      ),
      backgroundColor: Colors.grey,
      body: HomeChild(),
      //bottomNavigationBar: MyBottomBar(),
    );
  }
}
