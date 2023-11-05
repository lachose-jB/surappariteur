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
  const DocumentShild({Key? key}) : super(key: key);

  @override
  State<DocumentShild> createState() => _DocumentShildState();
}

class _DocumentShildState extends State<DocumentShild> {
  int columnCount = 2;
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
        child: GridView.count(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.all(_w / 60),
          crossAxisCount: columnCount,
          children: userDocs.map((doc) {
            return AnimationConfiguration.staggeredGrid(
              duration: const Duration(milliseconds: 500),
              columnCount: columnCount,
              position: 1,
              child: ListItem(
                width: _w,
                doc: doc,
                key: null,
              ),
            );
          }).toList(),
        ),
      ),
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
    return OpenContainer(
      closedBuilder: (_, openContainer) {
        return Container(
          margin: EdgeInsets.only(
            bottom: width / 30,
            left: width / 60,
            right: width / 60,
          ),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
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
                  Column(
                    children: <Widget>[
                      Text(
                        doc.description ?? 'No description available',
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
                _launchURL(doc.lienDoc);
              },
              child: const Text('Ouvrir le document'),
            ),
          ),
        );
      },
    );
  }
}

void _launchURL(String? url) async {
  if (url != null && await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Impossible d\'ouvrir le lien $url';
  }
}
