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
