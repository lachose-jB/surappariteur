import 'package:flutter/material.dart';

import '../../addonglobal/topbar.dart';
import '../../police/vueController/missioncontroler/childmission.dart';
import '../../police/vueController/missioncontroler/newMission.dart';
import '../notif/notifScreen.dart';


class MissionScreen extends StatefulWidget {
  static String routeName = "/mission";
  const MissionScreen({Key? key});

  @override
  _MissionScreenState createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBarS(
        onNotificationPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NotifScreen()));
        },
        PageName: "Mes Missions", // Pass the page name here
        tabController: _tabController,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BodyM(),
          // L'onglet "Missions à venir" sera vide
          Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MissionNew()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

