class UserData {
  late final String userId;
  late final String appariteurId;
  late final String name;
  late final String email;
  late final String tel;
  late final String sexe;
  late final String image;
  late final String adresse;
  late final String datenais;
  late final String lieunais;
  late final String rue;
  late final String codepostal;
  late final String ville;
  late final String pays;
  late final String niveau;
  late final String user;
  UserData({
    required this.userId,
    required this.appariteurId,
    required this.name,
    required this.email,
    required this.tel,
    required this.sexe,
    required this.image,
    required this.adresse,
    required this.datenais,
    required this.lieunais,
    required this.rue,
    required this.codepostal,
    required this.ville,
    required this.pays,
    required this.niveau,
    required this.user,
    required token,
  });
}

UserData userInit = UserData(
  userId: 'user_id',
  appariteurId: 'appariteur_id',
  name: 'name',
  email: 'email',
  tel: 'tel',
  sexe: 'sexe',
  image: 'image',
  adresse: 'adresse',
  datenais: 'datenais',
  lieunais: 'lieunais',
  rue: 'rue',
  codepostal: 'codepostal',
  ville: 'ville',
  pays: 'pays',
  niveau: 'niveau',
  user: 'user',
  token: null,
);
