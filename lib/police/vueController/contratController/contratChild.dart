import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../acteurs/contrat.dart';
import '../../helper/serveur/authentificateur.dart';

class ContratChild extends StatefulWidget {
  @override
  _ContratChildState createState() => _ContratChildState();
}

class _ContratChildState extends State<ContratChild> {
  List<Contrat>? contrats;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    print('Chargement des contrats...');
    setState(() {
      isLoading = true;
    });

    final loadedContrats = await AuthApi.getContrats();

    print('Contrats chargés:');
    print('Contrats : $loadedContrats');

    setState(() {
      contrats = loadedContrats;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : contrats == null
          ? Center(child: Text("Pas de contrats"))
          : AnimationLimiter(
        child: ListView.builder(
          itemCount: contrats!.length,
          padding: EdgeInsets.all(_w / 30),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemBuilder: (BuildContext c, int i) {
            final contrat = contrats![i];
            return AnimationConfiguration.staggeredList(
              position: i,
              delay: const Duration(milliseconds: 100),
              child: SlideAnimation(
                duration: const Duration(milliseconds: 2500),
                curve: Curves.fastLinearToSlowEaseIn,
                horizontalOffset: 30,
                verticalOffset: 300.0,
                child: ContratItem(width: _w, contrat: contrat),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ContratItem extends StatelessWidget {
  final double width;
  final Contrat contrat;

  ContratItem({required this.width, required this.contrat});

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
          title: Text('Type de contrat: ${contrat.typeContrat}'),
          subtitle: Text('Date de début: ${contrat.dateEmbauche}'),
          trailing: ElevatedButton(
            onPressed: () {
              // Ajoutez ici la logique pour télécharger le contrat
              // Vous pouvez utiliser le package 'url_launcher' pour ouvrir le lien dans le navigateur ou 'http' pour télécharger le fichier
            },
            child: Text('Télécharger Contrat'),
          ),
        ),
      ),
    );
  }
}
