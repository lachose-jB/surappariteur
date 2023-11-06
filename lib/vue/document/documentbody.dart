// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:surappariteur/vue/document/docniew.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../addonglobal/topbar.dart';
import '../../police/acteurs/userdoc.dart';
import '../../police/helper/serveur/authentificateur.dart';
import '../notif/notifScreen.dart';

class DocumentShild extends StatefulWidget {
  const DocumentShild({Key? key}) : super(key: key);

  @override
  State<DocumentShild> createState() => _DocumentShildState();
}

class _DocumentShildState extends State<DocumentShild> {
  List<Alldoc> userDocs = [];

  @override
  void initState() {
    super.initState();
    ShowUserDoc();
  }

  Future<void> ShowUserDoc() async {
    final userDoc = await AuthApi.DocUser();
    if (userDoc != null) {
      setState(() {
        userDocs = userDoc.alldoc;
      });
    } else {
      // Handle the failed connection here
    }
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: TopBarS(
        onNotificationPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotifScreen()),
          );
        },
        PageName: "Mes documents",
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DocumentNews()));
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
      body: AnimationLimiter(
          child: ListView.builder(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: EdgeInsets.all(_w / 60),
        itemCount: userDocs.length,
        itemBuilder: (BuildContext context, int index) {
          final doc = userDocs[index];
          return AnimationConfiguration.staggeredList(
            duration: const Duration(milliseconds: 500),
            position: index,
            child: ListItem(
              width: _w,
              doc: doc,
              key: null,
            ),
          );
        },
      )),
    );
  }
}

class ListItem extends StatelessWidget {
  final double width;
  final Alldoc doc;

  ListItem({
    required Key? key,
    required this.width,
    required this.doc,
  }) : super(key: key);

  Future<void> _openPDF() async {
    final url = doc.lienDoc; // URL du document PDF
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible d\'ouvrir le lien $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openPDF, // Appel de la fonction d'ouverture du PDF
      child: Container(
        width: MediaQuery.of(context).size.width *
            0.5, // Ajout de la largeur (80% de la largeur de l'écran)
        margin: EdgeInsets.only(
          bottom: width / 30,
          left: width / 60,
          right: width / 60,
          top: 20, // Ajoute un marginTop de 20 pixels
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent, // Couleur de l'ombre corrigée
              blurRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  doc.typeDoc,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
