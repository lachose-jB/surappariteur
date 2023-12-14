class FichePaie {
  final int id;
  final String mois;
  final String annee;
  final String fichier;
  final String dateCreate;

  FichePaie({
    required this.id,
    required this.mois,
    required this.annee,
    required this.fichier,
    required this.dateCreate,
  });

  factory FichePaie.fromJson(Map<String, dynamic> json) {
    return FichePaie(
      id: json['id'] as int,
      mois: json['mois'] as String,
      annee: json['annee'] as String,
      fichier: json['fichier'] as String,
      dateCreate: json['Datecreate'] as String,
    );
  }
}
