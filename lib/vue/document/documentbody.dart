// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Ouvre le lien du document lors du clic
      },
      child: Container(
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
              color: Colors.red,
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
