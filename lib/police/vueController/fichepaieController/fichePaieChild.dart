import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
    final loadedFichesPaie = await AuthApi.getFichesPaie();
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
                physics: const BouncingScrollPhysics(),
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

  @override
  Widget build(BuildContext context) {
    return FlipAnimation(
      duration: const Duration(milliseconds: 3000),
      curve: Curves.fastLinearToSlowEaseIn,
      flipAxis: FlipAxis.y,
      child: Card(
        surfaceTintColor: Colors.white,
        margin: EdgeInsets.only(bottom: width / 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFScreen(url: 'https://appariteur.com/admins/documents/${fiche.fichier}'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text('${fiche.mois} ${fiche.annee}', style: Theme.of(context).textTheme.headline6),
                    ),
                    Icon(Icons.check_circle, color: Colors.green) // Status icon example
                  ],
                ),
                SizedBox(height: 10),
                Text('Créée le: ${fiche.dateCreate}', style: Theme.of(context).textTheme.subtitle2),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Voir ', style: Theme.of(context).textTheme.bodyText1),
                    Icon(Icons.remove_red_eye, color: Theme.of(context).primaryColor),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class PDFScreen extends StatelessWidget {
  final String url;

  const PDFScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiche de Paie'),
      ),
      body: SfPdfViewer.network(url),
    );
  }
}
