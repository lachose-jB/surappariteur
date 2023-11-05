import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'planingviwer.dart';

class PlaningShild extends StatelessWidget {
  const PlaningShild({super.key});

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    int itemCount = 2;
    int columnCount = 2;
    return Scaffold(
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
                child: ListItem(width: _w),
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

  ListItem({required this.width});

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
              child: const Padding(
                padding: EdgeInsets.all(
                    16.0), // Ajustez le padding selon vos besoins
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Titre de taille responsive
                      Flexible(
                        child: Text(
                          'Titre de taille responsive',
                          style: TextStyle(
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
                            '12:00 AM', // Heure formatée
                            style: TextStyle(fontSize: 16.0),
                          ),
                          // Format date
                          Text(
                            '2023-11-01', // Date formatée
                            style: TextStyle(fontSize: 16.0),
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
              body:
                  PlaningViewer(), // Personnalisez le contenu selon vos besoins
            );
          },
        ),
      ),
    );
  }
}
