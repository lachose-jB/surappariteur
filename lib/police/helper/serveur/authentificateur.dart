// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surappariteur/police/acteurs/missionuser.dart';
import 'package:surappariteur/police/acteurs/userinfo.dart';

import '../../acteurs/fichepaie.dart';
import '../../acteurs/planning.dart';
import '../../acteurs/user.dart';
import '../../acteurs/userdoc.dart';

class AuthApi {
  static UserData? _loggedUserData;
  static String? tokenVar;

  static Future<UserData?> login(String email, String password) async {
    try {
      const url = 'https://appariteur.com/api/users/login.php';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'emailUser': email, 'passwordUser': password}),
      );
      if (response.statusCode == 200) {
        var rawResponse = response.bodyBytes;
        var responseBody = utf8.decode(rawResponse);
        print(responseBody);
        final data = jsonDecode(response.body);
        if (data['success'] == true) {

          final userData = data['userData'];
          tokenVar = data['token'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', tokenVar!);
          print(tokenVar);
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
            token: prefs.getString('token'), // Ajouter le token au modèle UserData
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
            token: prefs.getString('token'), // Ajouter le token au modèle UserData
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
  static Future<String?> getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  static Future<UserInfo?> InfoUser() async {
    const url = 'https://appariteur.com/api/users/infos_g.php';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenVar',
      },
    );
  try {
  final Map<String, dynamic> responseData = jsonDecode(response.body);
  final Map<String, dynamic> userData = responseData['userData'];

  final List<dynamic> infosPresData = userData['infos_pres'];
  final List<InfoPres> infosPresList = infosPresData.map((infos) {
  return InfoPres(
  jour: infos['jour'],
  date: infos['date'],
  matin: infos['matin'],
  soir: infos['soir'],
  );
  }).toList();

  final String? heureDays = userData['heure_days'];
  final String? heureWeek = userData['heure_week'];
  final String? heureMonth = userData['heure_month'];
  final String? heureYear = userData['heure_year'];

  final Map<String, dynamic> intervalWeekData = userData['intervalWeek'];
  final IntervalWeek intervalWeek = IntervalWeek(
  weekStart: intervalWeekData['week_start'],
  weekEnd: intervalWeekData['week_end'],
  );

  final String effeMis = userData['effe_mis'];

  final userInfo = UserInfo(
  infosPres: infosPresList,
  heureDays: heureDays,
  heureWeek: heureWeek,
  heureMonth: heureMonth,
  heureYear: heureYear,
  intervalWeek: intervalWeek,
  effeMis: effeMis,
  id_app: null, // Assurez-vous d'ajuster cela selon votre besoin
  );

  // Utilisez userInfo comme nécessaire
  } catch (e) {
  print('Erreur de décodage JSON : $e');
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
     // Assurez-vous que tokenVar est correctement initialisé

    try {
      final url =
          'https://appariteur.com/api/users/missioneffectuee.php?date_start=$dateDebuts&date_end=$dateFins';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenVar',
        },
      );

      if (response.statusCode == 200) {
        final docs = jsonDecode(response.body);
        print(tokenVar);

        var rawResponse = response.bodyBytes;
        var responseBody = utf8.decode(rawResponse);
        print(responseBody);

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
       // Assurez-vous que tokenVar est correctement initialisé

      const url = 'https://appariteur.com/api/user/fichepaie.php';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenVar',
        },
      );

      if (response.statusCode == 200) {

        var rawResponse = response.bodyBytes;

        var responseBody = utf8.decode(rawResponse);

        print(responseBody);
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
          print(fichesPaieList);
        }
      }
    } catch (e) {
      print('Erreur lors de la connexion à l\'API pour les fiches de paie : $e');
    }

    return null; // Gérer les erreurs comme vous le souhaitez
  }
  static Future<List<Planning>> fetchPlanningData(String startDate, String endDate) async {
    try {

      final url = 'https://appariteur.com/api/users/planning.php';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenVar',
        },
      );

      if (response.statusCode == 200) {
        final planningData = jsonDecode(response.body);
        // Récupérer la réponse brute
        var rawResponse = response.bodyBytes;


        var responseBody = utf8.decode(rawResponse);


        print(responseBody);
        if (planningData['success'] == true) {
          final List<dynamic> eventsDataList = planningData['result'] as List;

          if (eventsDataList.isEmpty) {
            // Aucun événement à afficher
            return [];
          }

          final List<Planning> PlanningList = eventsDataList.map((eventData) {
            return Planning(
              prestationId: eventData['prestation_id'],
              title: eventData['title'],
              startTime: eventData['startTime'],
              endTime: eventData['endTime'],
              lieu: eventData['lieu'],
              salle: eventData['salle'],
              duree: eventData['duree'],
              periode: eventData['periode'],
              dateEvent: eventData['date_event'],
              eventColor: eventData['eventColor'],
              btnCancel: eventData['btnCancel'],
            );
          }).toList();

          return PlanningList;
        }
      }
    } catch (e) {
      print('Erreur lors de la connexion à l\'API des événements : $e');
    }

    return []; // Gérer les erreurs comme vous le souhaitez
  }
  static Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      _loggedUserData = null;
      tokenVar = null;
      prefs.clear(); // Efface toutes les préférences partagées si nécessaire
    } catch (e) {
      print('Erreur lors de la déconnexion : $e');
    }
  }

}
