// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surappariteur/police/acteurs/missionuser.dart';
import 'package:surappariteur/police/acteurs/userinfo.dart';

import '../../acteurs/contrat.dart';
import '../../acteurs/disponibilites.dart';
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

          final userData = data['data'];
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
      final Map<String, dynamic> userData = responseData['data'];

      final String? heureWeek = userData['heure_week'];
      final String? heureMonth = userData['heure_month'];
      final String? heureYear = userData['heure_year'];



      final String effeMis = userData['effe_mis'];

      final UserInfo userInfo = UserInfo(
        heureWeek: heureWeek,
        heureMonth: heureMonth,
        heureYear: heureYear,
        effeMis: effeMis,

      );
      print(userInfo);
      return userInfo;
      // Retourne les informations utilisateur
    } catch (e) {
      print('Erreur de décodage JSON : $e');
      return null; // Retourne null en cas d'erreur de décodage JSON
    }
  }



  static Future<List<UserDoc>?> getUserDocuments() async {
    try {
      final response = await http.get(
        Uri.parse('https://appariteur.com/api/users/document.php'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenVar',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> documentsData = jsonDecode(response.body)['data'];

        final List<UserDoc> documentsList =
        documentsData.map((data) => UserDoc.fromJson(data)).toList();

        return documentsList;
      }
    } catch (e) {
      print('Erreur lors de la récupération des documents : $e');
    }

    return null;
  }


  static Future<MissionEffUser?> UserMission(String dateDebuts, String dateFins) async {
    try {
      final url = 'https://appariteur.com/api/users/missioneffectuee.php?date_start=$dateDebuts&date_end=$dateFins';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenVar',
        },
      );

      if (response.statusCode == 200) {
        // Attempt to correct the malformed JSON response
        String responseBody = response.body;
        int splitIndex = responseBody.indexOf('}}{') + 2; // Finds the index where the split should occur
        String firstJsonString = responseBody.substring(0, splitIndex) + "}"; // Corrects the first JSON part
        String secondJsonString = "{" + responseBody.substring(splitIndex + 1); // Corrects the second JSON part

        // Parse each JSON string
        var firstJson = jsonDecode(firstJsonString);
        var secondJson = jsonDecode(secondJsonString);

        // Combine the relevant data into a single object as expected by the model
        if (secondJson['success'] == true) {
          return MissionEffUser.fromJson({
            'missions': secondJson['data'],
            'totalHeure': secondJson['total_heure']
          });
        }
      }
    } catch (e) {
      print('Error while connecting to the API: $e');
    }
    return null;
  }
  static Future<List<FichePaie>?> getFichesPaie() async {
    try {
      // Assurez-vous que tokenVar est correctement initialisé

      const url = 'https://appariteur.com/api/users/fichepaie.php';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenVar',
        },
      );

      if (response.statusCode == 200) {
        var fichesPaieData = json.decode(utf8.decode(response.bodyBytes));

        if (fichesPaieData['success'] == true) {
          final List<dynamic> fichesPaieInfo = fichesPaieData['data'];

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

          print(fichesPaieList); // Vous pouvez imprimer les fichesPaieList ici si nécessaire
          return fichesPaieList;
        }
      } else {
        print('Erreur HTTP lors de la récupération des fiches de paie. Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la connexion à l\'API pour les fiches de paie : $e');
    }

    return null; // Gérer les erreurs comme vous le souhaitez
  }

  static Future<List<Planning>?> getPlanningData() async {
    try {
      if (tokenVar == null) {
        print('Error: Token is null');
        return null;
      }

      const url = 'https://appariteur.com/api/users/planning.php';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenVar',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> planningData = jsonDecode(response.body);

        if (planningData.isNotEmpty) {
          final List<Planning> eventsList = planningData.map((eventData) {
            return Planning.fromJson(eventData);
          }).toList();
          print(eventsList);
          return eventsList;
        } else {
          print('Planning data is empty');
          return <Planning>[];
        }
      } else {
        print('Failed to fetch planning data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching planning data: $e');
    }

    return null;
  }
  static Future<List<Contrat>?> getContrats() async {
    try {
      if (tokenVar == null) {
        print('Error: Token is null');
        return null;
      }

      const url = 'https://appariteur.com/api/users/contrat.php';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenVar',
        },
      );

      if (response.statusCode == 200) {
        var contratsData = json.decode(utf8.decode(response.bodyBytes));

        if (contratsData['success'] == true) {
          final List<dynamic> contratsInfo = contratsData['data'];

          if (contratsInfo.isEmpty) {
            // Aucun contrat à afficher
            return null;
          }

          final List<Contrat> contratsList = contratsInfo.map((contratData) {
            return Contrat(
              idContratApp: contratData['Id_contrat_app'],
              appariteurId: contratData['appariteur_id'],
              typeContrat: contratData['TypeContrat'],
              dateEmbauche: contratData['DateEmbauche'],
              dateFinContrat: contratData['DateFinContrat'],
              dateEdition: contratData['DateEdition'],
              disponibilite: contratData['Disponibilite'],
              nbrHeure: contratData['nbr_heure'],
              montantHeure: contratData['montant_heure'],
              nameFichier: contratData['name_fichier'],
            );
          }).toList();

          print(contratsList); // Vous pouvez imprimer les contratsList ici si nécessaire
          return contratsList;
        }
      } else {
        print('Erreur HTTP lors de la récupération des contrats. Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la connexion à l\'API pour les contrats : $e');
    }

    return null; // Gérer les erreurs comme vous le souhaitez
  }

  static Future<void> sendDisponibilites(List<Map<String, dynamic>> disponibilites) async {
    try {
      // Vérification du token
      if (tokenVar == null) {
        print('Error: Token is null');
        return;
      }
      const url = 'https://appariteur.com/api/users/disponibilites.php';
      final Map<String, dynamic> requestBody = {'updates': disponibilites};
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenVar',
        },
        body: jsonEncode(requestBody),
      );

      // Traitement de la réponse
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print('Disponibilités ajoutées avec succès');
        } else {
          print('Erreur lors de l\'ajout des disponibilités');
        }
      } else {
        print('Failed to add disponibilites. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending disponibilites: $e');
    }
  }
  static Future<List<Disponibilite>?> getDisponibilites() async {
    if (tokenVar == null) {
      print('Error: Token is null');
      return null;
    }

    const url = 'https://appariteur.com/api/users/disponibilites.php';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenVar',
        },
      );

      if (response.statusCode == 200) {
        var disponibilitesData = json.decode(utf8.decode(response.bodyBytes));
        if (disponibilitesData['success'] == true) {
          final List<dynamic> disponibilitesInfo = disponibilitesData['result'];

          if (disponibilitesInfo.isEmpty) {
            return null;
          }

          final List<Disponibilite> disponibilitesList = disponibilitesInfo.map((disponibiliteData) {
            return Disponibilite.fromJson(disponibiliteData);
          }).toList();

          print(disponibilitesList); // For debug
          return disponibilitesList;
        }
      } else {
        print('HTTP Error while fetching disponibilites. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error connecting to the API for disponibilites: $e');
    }

    return null; // Handle errors as you wish
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
