import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../acteurs/fichepaie.dart';
import '../../helper/serveur/authentificateur.dart';

class FichesPaieChild extends StatefulWidget {
  @override
  _FichesPaieChildState createState() => _FichesPaieChildState();
}

class _FichesPaieChildState extends State<FichesPaieChild> {
  List<FichePaie>? fichesPaie;

  @override
  void initState() {
    super.initState();
    loadFichesPaie();
  }

  Future<void> loadFichesPaie() async {
    print('Chargement des fiches paie...');
    final loadedFichesPaie = await AuthApi.getFichesPaie();
    print('Fiches de paies chargées:');
    print(loadedFichesPaie);
    setState(() {
      fichesPaie = loadedFichesPaie;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder<List<FichePaie>?>(
        future: AuthApi.getFichesPaie(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des fiches'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Pas de fiches"));
          } else {
            return AnimationLimiter(
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                padding: EdgeInsets.all(_w / 30),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemBuilder: (BuildContext c, int i) {
                  final fiche = snapshot.data![i];
                  return AnimationConfiguration.staggeredList(
                    position: i,
                    delay: const Duration(milliseconds: 100),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      horizontalOffset: 30,
                      verticalOffset: 300.0,
                      child: ListItem(width: _w, fiche: fiche),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final double width;
  final FichePaie fiche;

  ListItem({required this.width, required this.fiche});

  Future<void> downloadFiche(String fileName) async {
    final downloadUrl = 'https://appariteur.com/admins/documents/$fileName';

    // Ajoutez le schéma du lien (http:// ou https://) pour garantir que canLaunch fonctionne correctement
    if (await canLaunch('http://$downloadUrl') || await canLaunch('https://$downloadUrl')) {
      await launch(downloadUrl);
    } else {
      print('Could not launch $downloadUrl');
    }
  }


  @override
  Widget build(BuildContext context) {
    return FlipAnimation(
      duration: const Duration(milliseconds: 3000),
      curve: Curves.fastLinearToSlowEaseIn,
      flipAxis: FlipAxis.y,
      child: Container(
        margin: EdgeInsets.only(bottom: width / 20),
        height: width / 4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        child: ListTile(
          title: Text('${fiche.mois} ${fiche.annee}'),
          subtitle: Text('Date de création: ${fiche.dateCreate}'),
          trailing: ElevatedButton(
            onPressed: () {
              downloadFiche(fiche.fichier);
            },
            child: Text('Télécharger'),
          ),
        ),
      ),
    );
  }
}
