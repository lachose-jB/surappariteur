import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:surappariteur/police/acteurs/missionuser.dart';
import 'package:surappariteur/police/helper/serveur/authentificateur.dart';

class BodyM extends StatefulWidget {
  const BodyM({Key? key}) : super(key: key);

  @override
  _BodyMState createState() => _BodyMState();
}

class _BodyMState extends State<BodyM> {
  late Future<MissionEffUser?> futureMissions;

  @override
  void initState() {
    super.initState();
    futureMissions = retrieveUserMission('2023-01-01', '2023-12-31');
  }

  Future<MissionEffUser?> retrieveUserMission(String dateDebuts, String dateFins) async {
    print('Récupération des missions...');
    MissionEffUser? missions = await AuthApi.UserMission(dateDebuts, dateFins);
    if (missions != null) {
      print('Missions récupérées avec succès');
      for (var mission in missions.missionList) {
        print('Mission : ${mission.date}, ${mission.reference}, ${mission.etabli}, ${mission.duree}');
      }
    } else {
      print('Aucune mission à afficher');
    }
    return missions;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MissionEffUser?>(
      future: futureMissions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Erreur lors de la récupération des missions : ${snapshot.error}');
          return Text('Erreur lors de la récupération des missions');
        } else if (!snapshot.hasData) {
          print('Aucune mission à afficher');
          return Center(
              child:Text('Aucune mission à afficher'));
        } else {
          print('Missions récupérées avec succès');
          MissionEffUser missions = snapshot.data!;
          return ListView.builder(
            itemCount: missions.missionList.length,
            itemBuilder: (context, index) {
              Mission mission = missions.missionList[index];
              print('Mission $index : ${mission.date}, ${mission.reference}, ${mission.etabli}, ${mission.duree}');
              return ListTile(
                title: Text(mission.reference),
                subtitle: Text('${mission.etabli}, ${mission.duree}'),
              );
            },
          );
        }
      },
    );
  }
}
