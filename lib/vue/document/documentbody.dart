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
        padding: const EdgeInsets.all(25),
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
  final Alldoc doc;
  const ListItem({
    required Key? key,
    required this.doc,
    required double width,
  }) : super(key: key);

  Future<void> _openPDF() async {
    final url = doc.lienDoc; // URL du document PDF
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible d\'ouvrir le lien $url';
    }
  }

  Future<void> deleteDocument(BuildContext context) async {
    final bool deleteConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Voulez-vous vraiment supprimer ce document ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Oui'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Non'),
            ),
          ],
        );
      },
    );
    if (deleteConfirmed) {
      // Mettez ici la logique de suppression du document
      // Après la suppression, vous pouvez mettre à jour l'interface utilisateur ou rediriger l'utilisateur vers une autre page.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          padding: const EdgeInsets.all(5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFDBDCDC),
        ),
        onPressed: _openPDF,
        child: Row(
          children: [
            const SizedBox(width: 20),
            Expanded(child: Text(doc.typeDoc)),
            IconButton(
              icon: const Icon(Icons.delete,
                  color: Colors.black), // Icône de la corbeille
              onPressed: () => deleteDocument(
                  context), // Appel de la fonction de suppression
            ),
          ],
        ),
      ),
    );
  }
}
