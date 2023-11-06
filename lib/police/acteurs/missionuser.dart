class MissionEffUser {
  final List<Mission> result;
  final String month;
  final String monthyear;
  final String sum_heure;
  final int lastyear;
  final List<Year> years;

  MissionEffUser({
    required this.result,
    required this.month,
    required this.monthyear,
    required this.sum_heure,
    required this.lastyear,
    required this.years,
  });
}

class Mission {
  final String date;
  final String reference;
  final String etabli;
  final String duree;

  Mission({
    required this.date,
    required this.reference,
    required this.etabli,
    required this.duree,
  });
}

class Year {
  final String year;

  Year({
    required this.year,
  });
}

MissionEffUser missionEffUser = MissionEffUser(
  result: [], // Une liste de missions
  month: "June",
  monthyear: "June 2023",
  sum_heure: "58",
  lastyear: 2022,
  years: [], // Une liste d'années
);

// Accéder aux propriétés
List<Mission> missions = missionEffUser.result;
String month = missionEffUser.month;
String monthYear = missionEffUser.monthyear;
String sumHeure = missionEffUser.sum_heure;
int lastYear = missionEffUser.lastyear;
List<Year> years = missionEffUser.years;

Mission mission = Mission(
  date: "2023-06-25",
  reference: "azerty",
  etabli: "zzzz",
  duree: "58",
);

// Accéder aux propriétés
String date = mission.date;
String reference = mission.reference;
String etabli = mission.etabli;
String duree = mission.duree;

Year year = Year(
  year: "2022",
);

// Accéder aux propriétés
String yearValue = year.year;
