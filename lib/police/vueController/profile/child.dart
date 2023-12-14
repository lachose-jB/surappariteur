import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surappariteur/police/vueController/profile/profileimg.dart';
import 'package:surappariteur/police/vueController/profile/profilpage.dart';
import 'package:surappariteur/vue/aide/aidebody.dart';
import 'package:surappariteur/vue/contrat/contrabody.dart';
import 'package:surappariteur/vue/document/documentbody.dart';
import 'package:surappariteur/vue/login/loginvue.dart';
import 'package:surappariteur/vue/notif/notifScreen.dart';

import '../../../vue/parametres/paramettrebody.dart';
import 'firscontaint.dart';

class ProfileChild extends StatelessWidget {
  const ProfileChild({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const ProfileImg(),
          const SizedBox(height: 20),
          FirsContentPro(
            text: "Mon Compte",
            icon: "assets/icons/User Icon.svg",
            press: () => {
              Navigator.push(context, SlideTransition1(const ProfilePage())),
            },
          ),
          FirsContentPro(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () => {
              Navigator.push(
                context,
                SlideTransition1(NotifScreen()),
              ),
            },
          ),
          FirsContentPro(
            text: "Contrat",
            icon: "assets/icons/task.svg",
            press: () => {
              Navigator.push(
                context,
                SlideTransition1(ContraBody()),
              ),
            },
          ),
          FirsContentPro(
            text: "Document",
            icon: "assets/icons/doc.svg",
            press: () => {
              Navigator.push(
                context,
                SlideTransition1(const DocumentShild()),
              ),
            },
          ),
          FirsContentPro(
            text: "Paramètres",
            icon: "assets/icons/Settings.svg",
            press: () => {
              Navigator.push(
                context,
                SlideTransition1(Parrametre()),
              ),
            },
          ),
          FirsContentPro(
            text: "Aide",
            icon: "assets/icons/Question mark.svg",
            press: () => {
              Navigator.push(
                context,
                SlideTransition1(AideBody()),
              ),
            },
          ),
          FirsContentPro(
              text: "Déconnexion",
              icon: "assets/icons/Log out.svg",
              press: () async {
                SharedPreferences share = await SharedPreferences.getInstance();
                share.clear();
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginVue()),
                );
              }),
        ],
      ),
    );
  }
}

class SlideTransition1 extends PageRouteBuilder {
  final Widget page;
  SlideTransition1(this.page)
      : super(
            pageBuilder: (context, animation, anotherAnimation) => page,
            transitionDuration: const Duration(milliseconds: 1000),
            reverseTransitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  parent: animation,
                  reverseCurve: Curves.fastOutSlowIn);
              return SlideTransition(
                position: Tween(
                        begin: const Offset(1.0, 0.0),
                        end: const Offset(0.0, 0.0))
                    .animate(animation),
                child: page,
              );
            });
}
