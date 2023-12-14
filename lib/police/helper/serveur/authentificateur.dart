// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:surappariteur/police/acteurs/missionuser.dart';
import 'package:surappariteur/police/acteurs/userinfo.dart';

import '../../acteurs/fichepaie.dart';
import '../../acteurs/user.dart';
import '../../acteurs/userdoc.dart';

class AuthApi {
  static UserData? _loggedUserData;
  static var tokenVar;
  static Future<UserData?> login(String email, String password) async {
    try {
      const url = 'https://appariteur.com/api/user/login.php';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'emailUser': email, 'passwordUser': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final userData = data['userData'];
          tokenVar = data['token'];
          _loggedUserData = UserData(
            userId: userData['user_id'],
            appariteurId: userData['appariteur_id'],
            name: userData['name'],
            email: userData['email'],
            tel: userData['tel'],
            sexe: userData['sexe'],
            image: userData['image'],
            adresse: userData['adresse'],
            datenais: userData['datenais'],
            lieunais: userData['lieunais'],
            rue: userData['rue'],
            codepostal: userData['codepostal'],
            ville: userData['ville'],
            pays: userData['pays'],
            niveau: userData['niveau'],
            user: userData['user'],
            token: tokenVar, // Ajouter le token au modèle UserData
          );
          return UserData(
            userId: userData['user_id'],
            appariteurId: userData['appariteur_id'],
            name: userData['name'],
            email: userData['email'],
            tel: userData['tel'],
            sexe: userData['sexe'],
            image: userData['image'],
            adresse: userData['adresse'],
            datenais: userData['datenais'],
            lieunais: userData['lieunais'],
            rue: userData['rue'],
            codepostal: userData['codepostal'],
            ville: userData['ville'],
            pays: userData['pays'],
            niveau: userData['niveau'],
            user: userData['user'],
            token: tokenVar, // Ajouter le token au modèle UserData
          );

        }
      }
    } catch (e) {
      print('Erreur lors de la connexion à l\'API : $e');
    }
    return null; // Gérer les erreurs comme vous le souhaitez
  }
  static UserData? getLoggedUserData() {
    return _loggedUserData;
  }
  static Future<UserInfo?> InfoUser() async {
    try {
      final tokenInfo = tokenVar; // Ensure tokenVar is correctly initialized

      const url = 'https://appariteur.com/api/users/infos_g.php';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenInfo',
        },
      );

      if (response.statusCode == 200) {
        final info = jsonDecode(response.body);
        print('API Response: $info'); // Print the entire response for debugging

        if (info['success'] == true) {
          final userInfo = info['userData'];
          final intervalWeekData = userInfo['intervalWeek'];
          final intervalWeek = IntervalWeek(
            weekStart: intervalWeekData['week_start'],
            weekEnd: intervalWeekData['week_end'],
          );
          final infosPres = userInfo['infos_pres'] as List<dynamic>;
          final List<InfoPres> infosPresList = infosPres.map((infos) {
            return InfoPres(
              jour: infos['jour'],
              date: infos['date'],
              matin: infos['matin'],
              soir: infos['soir'],
            );
          }).toList();

          final donnees = UserInfo(
            heureDays: userInfo['heure_days'],
            heureWeek: userInfo['heure_week'],
            heureMonth: userInfo['heure_month'],
            heureYear: userInfo['heure_year'],
            infosPres: infosPresList,
            intervalWeek: intervalWeek,
            effeMis: userInfo['effe_mis'],
            id_app: null, // There might be a typo here, check the field name
          );

          print('Donnees: $donnees'); // Print UserInfo for debugging
          return donnees;
        } else {
          print('API Error: ${info['message']}');
        }
      } else {
        print('API Error - Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during API connection: $e');
    }
    return null; // Handle errors as needed
  }


  static Future<UserDoc?> DocUser() async {
    late var tokenInfo;
    try {
      tokenInfo =
          tokenVar; // Assurez-vous que tokenVar est correctement initialisé

      const url = 'https://appariteur.com/api/users/document.php';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenInfo',
        },
      );

      if (response.statusCode == 200) {
        final docs = jsonDecode(response.body);
        if (docs['success'] == true) {
          final List<dynamic> docInfo = docs['result'] as List;
          print(docInfo);
          print("+++++++++++++++++++++++++++++++++++++++++++");
          final List<Alldoc> alldocList = docInfo.map((infos) {
            return Alldoc(
              id: infos['id'],
              typeDoc: infos['type_doc'],
              description: infos['description'] ??
                  'No description available', // Provide a default value
              lienDoc: infos['lien_doc'],
            );
          }).toList();
          return UserDoc(
            alldoc: alldocList,
          );
        }
      }
    } catch (e) {
      print('Erreur lors de la connexion à l\'API : $e');
    }
    return null; // Gérer les erreurs comme vous le souhaitez
  }

  static Future<MissionEffUser?> UserMission(
      String dateDebuts, String dateFins) async {
    final tokenInfo =
        tokenVar; // Assurez-vous que tokenVar est correctement initialisé

    try {
      final url =
          'https://appariteur.com/api/users/missioneffectuee.php?date_start=$dateDebuts&date_end=$dateFins';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenInfo',
        },
      );

      if (response.statusCode == 200) {
        final docs = jsonDecode(response.body);

        if (docs['success'] == true) {
          final List<dynamic> missions = docs['result'] as List;

          if (missions.isEmpty) {
            // Aucune mission à afficher
            return null;
          }

          final List<Mission> missionList = missions.map((missionData) {
            String date = missionData['date'] ?? 'null';
            String reference = missionData['reference'] ?? 'null';
            String etabli = missionData['etabli'] ?? 'null';
            String duree = missionData['duree'] ?? 'null';

            return Mission(
              date: date,
              reference: reference,
              etabli: etabli,
              duree: duree,
            );
          }).toList();

          final month = docs['month'];
          final monthyear = docs['monthyear'];
          final sumHeure = docs['sum_heure'];
          final lastyear = docs['lastyear'];

          final List<dynamic> yearsData = docs['years'] as List;
          final List<Year> yearList = yearsData.map((yearData) {
            return Year(
              year: yearData['year'],
            );
          }).toList();

          return MissionEffUser(
            missionList: missionList,
            month: month,
            monthyear: monthyear,
            sum_heure: sumHeure,
            lastyear: lastyear,
            years: yearList,
          );
        }
      }
    } catch (e) {
      print('Erreur lors de la connexion à l\'API : $e');
    }

    return null; // Gérer les erreurs comme vous le souhaitez
  }
  static Future<List<FichePaie>?> getFichesPaie() async {
    try {
      final tokenInfo = tokenVar; // Assurez-vous que tokenVar est correctement initialisé

      const url = 'https://appariteur.com/api/user/fichepaie.php';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenInfo',
        },
      );

      if (response.statusCode == 200) {
        final fichesPaieData = jsonDecode(response.body);

        if (fichesPaieData['success'] == true) {
          final List<dynamic> fichesPaieInfo = fichesPaieData['result'] as List;

          if (fichesPaieInfo.isEmpty) {
            // Aucune fiche de paie à afficher
            return null;
          }

          final List<FichePaie> fichesPaieList = fichesPaieInfo.map((ficheData) {
            return FichePaie(
              id: ficheData['id'],
              mois: ficheData['mois'],
              annee: ficheData['annee'],
              fichier: ficheData['fichier'],
              dateCreate: ficheData['Datecreate'],
            );
          }).toList();

          return fichesPaieList;
        }
      }
    } catch (e) {
      print('Erreur lors de la connexion à l\'API pour les fiches de paie : $e');
    }

    return null; // Gérer les erreurs comme vous le souhaitez
  }

}
