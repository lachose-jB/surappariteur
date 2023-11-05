// ignore_for_file: deprecated_member_use

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../addonglobal/topbar.dart';
import '../../police/acteurs/userdoc.dart';
import '../../police/helper/serveur/authentificateur.dart';
import '../notif/notifScreen.dart';

class DocumentShild extends StatefulWidget {
  const DocumentShild({super.key});

  @override
  State<DocumentShild> createState() => _DocumentShildState();
}

class _DocumentShildState extends State<DocumentShild> {
  int itemCount = 0;
  int columnCount = 2;
  var DocName = "";
  var DocDescription = "";
  var DocLien = "";
  List<Alldoc> userDocs = [];

  Future<void> ShowUserDoc() async {
    final userDoc = await AuthApi.DocUser();
    if (userDoc != null) {
      itemCount = userDoc.alldoc.length;
      print(userDoc);
      for (int i = 1; i < itemCount; i++) {
        DocName = userDoc.alldoc[i].typeDoc;
        DocDescription = userDoc.alldoc[i].description;
        DocLien = userDoc.alldoc[i].lienDoc;
        print(DocLien);
        print(i);
      }
      print(itemCount);
    } else {
      print(userDoc);
      // Gérer la connexion échouée ici
    }
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    ShowUserDoc();
    return Scaffold(
      appBar: TopBarS(
        onNotificationPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NotifScreen()));
        },
        PageName: "Mes documents", // Pass the page name here
      ),
      backgroundColor: Colors.white,
      body: AnimationLimiter(
        child: GridView.count(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.all(_w / 60),
          crossAxisCount: columnCount,
          children: List.generate(
            itemCount,
            (int index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 500),
                columnCount: columnCount,
                child: ListItem(
                  width: _w,
                  DocName: DocName,
                  DocDescription: DocDescription,
                  DocLien: DocLien,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final double width;
  final String DocName;
  final String DocDescription;
  final String DocLien;

  ListItem({
    required this.width,
    required this.DocName,
    required this.DocDescription,
    required this.DocLien,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleAnimation(
      duration: const Duration(milliseconds: 100),
      curve: Curves.fastEaseInToSlowEaseOut,
      scale: 1.5,
      child: FadeInAnimation(
        child: OpenContainer(
          closedBuilder: (_, openContainer) {
            return Container(
              margin: EdgeInsets.only(
                bottom: width / 30,
                left: width / 60,
                right: width / 60,
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                    16.0), // Ajustez le padding selon vos besoins
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Titre de taille responsive
                      Flexible(
                        child: Text(
                          DocName,
                          style: const TextStyle(
                            fontSize:
                                18.0, // Ajustez la taille de police selon vos besoins
                            fontWeight: FontWeight
                                .bold, // Optionnel : ajustez la graisse de la police
                          ),
                        ),
                      ),
                      // Colonne contenant l'heure et la date
                      Column(
                        children: <Widget>[
                          // Format heure
                          Text(
                            DocDescription, // Heure formatée
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          openColor: Colors.transparent,
          closedElevation: 20.0,
          closedColor: Colors.transparent,
          openBuilder: (_, closeContainer) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: const Text('Retour'),
                leading: IconButton(
                  onPressed: closeContainer,
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Ouvrez le document lorsque le bouton est appuyé
                    _launchURL(DocLien);
                  },
                  child: const Text('Ouvrir le document'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Impossible d\'ouvrir le lien $url';
  }
}
