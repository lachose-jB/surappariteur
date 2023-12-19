import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:surappariteur/police/acteurs/planning.dart';
import 'dart:convert';

class MissionListScreen extends StatelessWidget {
  final List<Planning> plannings;

  const MissionListScreen({
    Key? key,
    required this.plannings, required missionEffUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des missions'),
      ),
      body: ListView.builder(
        itemCount: plannings.length, // Utilisez la liste des plannings directement
        itemBuilder: (context, index) {
          final Planning planning = plannings[index];

          return Card(
            child: ListTile(
              title: Text(planning.title),
              subtitle: Text(planning.lieu),
              trailing: Text(planning.duree.toString()), // Assurez-vous de convertir en String si nécessaire
            ),
          );
        },
      ),
    );
  }
}
