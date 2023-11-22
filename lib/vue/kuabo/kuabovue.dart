import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surappariteur/boddy.dart';

import '../../addonglobal/bottombar.dart';

class Kuabo extends StatefulWidget {
  static String routeName = "/kuabo";
  const Kuabo({super.key});

  @override
  State<Kuabo> createState() => _KuaboState();
}

class _KuaboState extends State<Kuabo> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    animationController.repeat(
        reverse: true); // Use repeat without specifying loop count

    animation = Tween<double>(begin: 0.5, end: 8.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    checkLoginAndNavigate();
  }

  Future<void> checkLoginAndNavigate() async {
    bool isUserLoggedIn = await isLogin();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isUserLoggedIn ? const MyBottomNav() : const BoddyD(),
        ),
      );
    });
  }

  Future<bool> isLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("isLogin") ?? false;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.80),
                blurRadius: animation.value + animation.value,
                spreadRadius: animation.value,
                offset: Offset(animation.value, animation.value),
              ),
            ],
          ),
          child: Image.asset(
            "assets/images/logo.jpg",
            height: 80,
          ),
        ),
      ),
    );
  }
}
