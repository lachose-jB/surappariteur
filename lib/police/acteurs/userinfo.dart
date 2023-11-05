class UserInfo {
  final List<InfoPres> infosPres;
  final String? heureDays;
  final String? heureWeek;
  final String? heureMonth;
  final String? heureYear;
  final IntervalWeek intervalWeek;
  final String effeMis;

  UserInfo({
    required this.infosPres,
    this.heureDays,
    this.heureWeek,
    this.heureMonth,
    this.heureYear,
    required this.intervalWeek,
    required this.effeMis,
    required id_app,
  });
}

class InfoPres {
  final String jour;
  final String date;
  final String matin;
  final String soir;

  InfoPres({
    required this.jour,
    required this.date,
    required this.matin,
    required this.soir,
  });
}

class IntervalWeek {
  final String weekStart;
  final String weekEnd;

  IntervalWeek({
    required this.weekStart,
    required this.weekEnd,
  });
}
