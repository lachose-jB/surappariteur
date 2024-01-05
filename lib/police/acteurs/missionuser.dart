class MissionEffUser {
  List<Mission> missions;
  String totalHeure;

  MissionEffUser({required this.missions, required this.totalHeure});

  factory MissionEffUser.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Mission> missionList = list.map((i) => Mission.fromJson(i)).toList();
    return MissionEffUser(
      missions: missionList,
      totalHeure: json['total_heure'],
    );
  }
}

class Mission {
  String date;
  String reference;
  String etabli;
  String duree;

  Mission({required this.date, required this.reference, required this.etabli, required this.duree});

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      date: json['date'],
      reference: json['reference'],
      etabli: json['etabli'],
      duree: json['duree'],
    );
  }
}
