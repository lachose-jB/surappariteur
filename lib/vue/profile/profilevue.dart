import 'package:flutter/material.dart';

import '../../addonglobal/topbar.dart';
import '../../police/vueController/profile/child.dart';
import '../notif/notifScreen.dart';

class ProfileVue extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileVue({Key? key}) : super(key: key);

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
      backgroundColor: Colors.blueAccent,
      body: ProfileChild(),
    );
  }
}
