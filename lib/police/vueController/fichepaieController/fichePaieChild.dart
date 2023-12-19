import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../acteurs/fichepaie.dart';
import '../../helper/serveur/authentificateur.dart';


class FichesPaieChild extends StatefulWidget {
@override
_FichesPaieChildState createState() => _FichesPaieChildState();
}

class _FichesPaieChildState extends State<FichesPaieChild> {

  List<FichePaie>? fichesPaie;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadFichesPaie();
  }


  Future<void> loadFichesPaie() async {

    print('Chargement des fiches paie...');
    setState(() {
      isLoading = true;
    });

    final loadedFichesPaie = await AuthApi.getFichesPaie();

    print('Fiches de paies chargées:');
    print(loadedFichesPaie);

    setState(() {
      fichesPaie = loadedFichesPaie;
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : fichesPaie == null
          ? Center(child: Text("Pas de fiches"))
          : AnimationLimiter(
        child: ListView.builder(
          itemCount: fichesPaie!.length,
          padding: EdgeInsets.all(_w / 30),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (BuildContext c, int i) {
            final fiche = fichesPaie![i];
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
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final double width;
  final FichePaie fiche;

  ListItem({required this.width, required this.fiche});

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
              // Ajoutez ici la logique pour télécharger la fiche
              // Vous pouvez utiliser le package 'url_launcher' pour ouvrir le lien dans le navigateur ou 'http' pour télécharger le fichier
            },
            child: Text('Télécharger'),
          ),
        ),
      ),
    );
  }
}
