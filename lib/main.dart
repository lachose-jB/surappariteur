import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surappariteur/vue/kuabo/kuabovue.dart';
import 'package:surappariteur/vue/login/loginvue.dart';
import 'addonglobal/bottombar.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _defaultHome = new LoginVue(); // Page par défaut

  @override
  void initState() {
    super.initState();
    _checkFirstSeen();
  }

  Future _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      String? token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        _defaultHome = new LoginVue();
      } else {
        _defaultHome = new MyBottomNav();
      }
    } else {
      await prefs.setBool('seen', true);
      _defaultHome = new Kuabo();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: _defaultHome,
    );
  }
}
