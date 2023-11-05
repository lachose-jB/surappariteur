import 'package:flutter/material.dart';

class PlaningNew extends StatefulWidget {
  const PlaningNew({Key? key});
  @override
  State<PlaningNew> createState() => _PlaningNewState();
}

class UserAvailability {
  DateTime date;
  TimeOfDay heureDebut;
  TimeOfDay heureFin;

  UserAvailability(
      {required this.date, required this.heureDebut, required this.heureFin});
}

class _PlaningNewState extends State<PlaningNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enregistrer vos Disponibilités'),
        leading: IconButton(
          icon: const Icon(Icons.close), // Utilisez l'icône de croix (X)
          onPressed: () {
            Navigator.of(context)
                .pop(); // Vous pouvez utiliser Navigator pour revenir en arrière
          },
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
