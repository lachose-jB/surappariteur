import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:surappariteur/police/acteurs/missionuser.dart';
import 'package:surappariteur/police/helper/serveur/authentificateur.dart';

class BodyM extends StatefulWidget {
  const BodyM({Key? key}) : super(key: key);

  @override
  State<BodyM> createState() => _BodyPvState();
}

class _BodyPvState extends State<BodyM> with SingleTickerProviderStateMixin {
  late var dateDebuts;
  late var dateFins;
  late String Date;
  late String Reference;
  late String Etablissement;
  late String Duree;
  var TotalMissionEffectuer = 0;
  var FusturMission = 0;
  late Mission mission;
  List<Mission> listMission = [];
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _animation2;
  late TextEditingController startDateController;
  late TextEditingController endDateController;

  Future<void> showUserMission(var dateDebuts, var dateFins) async {
    final userMiss = await AuthApi.UserMission(dateDebuts, dateFins);

    if (userMiss != null) {
      setState(() {
        listMission = userMiss.missionList;
        TotalMissionEffectuer = listMission.length;
      });

      // Vous pouvez parcourir la liste des missions ici
      for (var mission in listMission) {
        Date = mission.date;
        Reference = mission.reference;
        Etablissement = mission.etabli;
        Duree = mission.duree;
      }
    } else {
      setState(() {
        TotalMissionEffectuer = 0;
        listMission
            .clear(); // Réinitialisez la liste en cas d'erreur ou de valeur nulle
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startDateController = TextEditingController();
    endDateController = TextEditingController();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      });

    _animation2 = Tween<double>(begin: -30, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dateDebuts = '2023-06';
    dateFins = '2023-11';
    showUserMission(dateDebuts, dateFins);
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          Container(
            color: Colors.white70,
            // Couleur de fond blanche
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.44,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x3F14181B),
                          offset: Offset(0, 3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Missions éffectués',
                            textAlign: TextAlign.center, // Text content
                            style: TextStyle(
                              fontSize: 24, /* Income */
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 2, 0, 0),
                            child: Text(
                              '$TotalMissionEffectuer',
                              /* +$12,402 */
                              textAlign: TextAlign.center, // Text content
                              style: const TextStyle(
                                fontSize: 30, /* Income */
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x3F14181B),
                          offset: Offset(0, 3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Mission à venir',
                            textAlign: TextAlign.center, // Text content
                            style: TextStyle(
                              fontSize: 24, // Adjust the font size as needed
                              // You can also customize other text styles here, like color, font weight, etc.
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 2, 0, 0),
                            child: Text(
                              '$FusturMission',
                              textAlign: TextAlign.center, // Text content
                              style: const TextStyle(
                                fontSize: 30, // Adjust the font size as needed
                                // You can also customize other text styles here, like color, font weight, etc.
                              ), /* Income */
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimationLimiter(
            child: Container(
              margin: const EdgeInsets.only(top: 175.0),
              // Ajoute un marginTop de 155 pixels
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: TotalMissionEffectuer,
                itemBuilder: (BuildContext context, int index) {
                  // Obtenez la mission actuelle
                  Mission mission = listMission[index];

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 100),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      horizontalOffset: 30,
                      verticalOffset: 300.0,
                      child: FlipAnimation(
                        duration: const Duration(milliseconds: 3000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        flipAxis: FlipAxis.y,
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: w / 20, left: w / 28, right: w / 28),
                          height: w / 5,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: 0, top: 0, left: 0),
                                width: 280,
                                height: 84,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 10, 5),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Top TextView
                                        Text(
                                          mission.etabli,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 1),

                                        // Row with TextViews
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              mission.duree,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Text(
                                              mission.date,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Add your edit icon onPressed functionality here
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget homePageCardsGroup(
    Color color,
    IconData icon,
    String title,
    BuildContext context,
    Widget route,
    Color color2,
    IconData icon2,
    String title2,
    Widget route2,
  ) {
    double w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: w / 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          homePageCard(
            color,
            icon,
            title,
            context,
            route,
          ),
          homePageCard(
            color2,
            icon2,
            title2,
            context,
            route2,
          ),
        ],
      ),
    );
  }

  Widget homePageCard(
    Color color,
    IconData icon,
    String title,
    BuildContext context,
    Widget route,
  ) {
    double w = MediaQuery.of(context).size.width;
    return Opacity(
      opacity: _animation.value,
      child: Transform.translate(
        offset: Offset(0, _animation2.value),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return route;
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            height: w / 2,
            width: w / 2.4,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff040039).withOpacity(.15),
                  blurRadius: 99,
                ),
              ],
              borderRadius: const BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(),
                Container(
                  height: w / 8,
                  width: w / 8,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color.withOpacity(.6),
                  ),
                ),
                Text(
                  title,
                  maxLines: 4,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(.5),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
