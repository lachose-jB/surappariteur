import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surappariteur/vue/kuabo/addon/child.dart';

import '../../addonglobal/bottombar.dart';

class Kuabo extends StatefulWidget {
  static String routeName = "/kuabo";
  const Kuabo({super.key});

  @override
  State<Kuabo> createState() => _KuaboState();
}

class _KuaboState extends State<Kuabo> {
  @override
  void initState() {
    super.initState();

    isLogin().then((value) {
      Timer(const Duration(seconds: 1), () {
        if (value) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyBottomNav()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KuaboChild()),
          );
        }
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<bool> isLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("isLogin") != null && pref.getBool("isLogin")!) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
