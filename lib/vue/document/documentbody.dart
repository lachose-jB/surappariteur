import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../addonglobal/topbar.dart';
import '../../police/acteurs/userdoc.dart';
import '../../police/helper/serveur/authentificateur.dart';
import '../notif/notifScreen.dart';
import 'docniew.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentShild extends StatefulWidget {
  const DocumentShild({Key? key}) : super(key: key);

  @override
  State<DocumentShild> createState() => _DocumentShildState();
}

class _DocumentShildState extends State<DocumentShild> {
  List<UserDoc> userDocs = [];

  @override
  void initState() {
    super.initState();
    ShowUserDoc();
  }

  Future<void> ShowUserDoc() async {
    final userDoc = await AuthApi.getUserDocuments();
    if (userDoc != null) {
      setState(() {
        userDocs = userDoc.toList();
      });
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
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(25),
          itemCount: userDocs.length,
          itemBuilder: (BuildContext context, int index) {
            final doc = userDocs[index];
            return AnimationConfiguration.staggeredList(
              duration: const Duration(milliseconds: 500),
              position: index,
              child: SlideAnimation(
                duration: const Duration(milliseconds: 2500),
                curve: Curves.fastLinearToSlowEaseIn,
                horizontalOffset: 30,
                verticalOffset: 300.0,
                child: FlipAnimation(
                  flipAxis: FlipAxis.y,
                  duration: const Duration(milliseconds: 3000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Card(
                    surfaceTintColor: Colors.white,
                    margin: EdgeInsets.only(bottom: _w / 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFScreen(url: 'https://appariteur.com/admins/documents/${doc.docName}'),
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
                                  child: Text(doc.typeDoc, style: Theme.of(context).textTheme.headline6),
                                ),
                                Icon(Icons.check_circle, color: Colors.green)
                              ],
                            ),
                            SizedBox(height: 10),
                            Text('Fichier: ${doc.docName}', style: Theme.of(context).textTheme.subtitle2),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('Voir ', style: Theme.of(context).textTheme.bodyText1),
                                  Icon(Icons.remove_red_eye, color: Theme.of(context).primaryColor),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
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
        title: const Text('Document'),
      ),
      body: SfPdfViewer.network(url),
    );
  }
}
