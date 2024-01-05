import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:surappariteur/vue/login/loginvue.dart';

import 'addonglobal/size_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        Locale('fr', ''), // Français
        Locale('en', ''), // Anglais (si nécessaire)
      ],
      debugShowCheckedModeBanner: false,
      title: 'Appariteur',
      home: LoginVue(),
      // Créez une instance de SplashScreen
    );
  }
}