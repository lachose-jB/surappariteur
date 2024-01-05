import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:surappariteur/police/acteurs/missionuser.dart';
import 'package:surappariteur/police/helper/serveur/authentificateur.dart';

class BodyM extends StatefulWidget {
  const BodyM({Key? key}) : super(key: key);

  @override
  _BodyMState createState() => _BodyMState();
}

class _BodyMState extends State<BodyM> {
  DateTime? startDate; // Initially null
  DateTime? endDate; // Initially null
  late Future<MissionEffUser?> futureMissions;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now().subtract(Duration(days: 365)); // Default start date
    endDate = DateTime.now(); // Default end date
    futureMissions = retrieveUserMission();
  }

  Future<MissionEffUser?> retrieveUserMission() async {
    if (startDate != null && endDate != null) {
      String formatStartDate = "${startDate!.year}-${startDate!.month.toString().padLeft(2,'0')}-${startDate!.day.toString().padLeft(2,'0')}";
      String formatEndDate = "${endDate!.year}-${endDate!.month.toString().padLeft(2,'0')}-${endDate!.day.toString().padLeft(2,'0')}";
      return AuthApi.UserMission(formatStartDate, formatEndDate);
    }
    return null; // If both dates aren't selected, don't fetch data
  }

  selectDate(BuildContext context, {required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (isStart ? startDate : endDate) ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101)
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
        // Refresh the missions list only if both dates are picked
        if (startDate != null && endDate != null) {
          futureMissions = retrieveUserMission();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double padding = screenSize.width * 0.02;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => selectDate(context, isStart: true),
                  child: Text(
                    'Date de Début: ${startDate?.toLocal().toString().split(' ')[0] ?? 'Select'}',
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
              SizedBox(width: padding),
              Expanded(
                child: TextButton(
                  onPressed: () => selectDate(context, isStart: false),
                  child: Text(
                    'Date de Fin: ${endDate?.toLocal().toString().split(' ')[0] ?? 'Select'}',
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<MissionEffUser?>(
            future: futureMissions,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur lors de la récupération des missions'));
              } else if (!snapshot.hasData || snapshot.data!.missions.isEmpty) {
                return Center(child: Text('Aucune mission à afficher'));
              } else {
                return AnimationLimiter(
                  child: ListView.builder(
                    itemCount: snapshot.data!.missions.length,
                    itemBuilder: (context, index) {
                      Mission mission = snapshot.data!.missions[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Card(
                              margin: EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Icon(Icons.assignment, color: Theme.of(context).primaryColor),
                                title: Text(mission.reference),
                                subtitle: Text('${mission.etabli}, ${mission.duree}'),
                                trailing: Text(mission.date),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
