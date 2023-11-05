class Alldoc {
  final id;
  final String typeDoc;
  final String description;
  final String lienDoc;

  Alldoc({
    required this.id,
    required this.typeDoc,
    required this.description,
    required this.lienDoc,
  });
}

class UserDoc {
  final List<Alldoc> alldoc;

  UserDoc({required this.alldoc});
}
