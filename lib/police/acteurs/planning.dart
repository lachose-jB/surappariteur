// event_model.dart

class Planning {
  final int prestationId;
  final String title;
  final String startTime;
  final String endTime;
  final String lieu;
  final String salle;
  final int duree;
  final String periode;
  final String dateEvent;
  final String eventColor;
  final bool btnCancel;

  Planning({
    required this.prestationId,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.lieu,
    required this.salle,
    required this.duree,
    required this.periode,
    required this.dateEvent,
    required this.eventColor,
    required this.btnCancel,
  });

  factory Planning.fromJson(Map<String, dynamic> json) {
    return Planning(
      prestationId: json['prestation_id'],
      title: json['title'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      lieu: json['lieu'],
      salle: json['salle'],
      duree: json['duree'],
      periode: json['periode'],
      dateEvent: json['date_event'],
      eventColor: json['eventColor'],
      btnCancel: json['btnCancel'],
    );
  }
}
