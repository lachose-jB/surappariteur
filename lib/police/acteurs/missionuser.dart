  class MissionEffUser {
    final List<Mission> missionList;
    final String month;
    final String monthyear;
    final String? sum_heure; // Modifier String en String?
    final int lastyear;
    final List<Year> years;

    MissionEffUser({
      required this.missionList,
      required this.month,
      required this.monthyear,
      this.sum_heure, // Modifier String en String?
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
