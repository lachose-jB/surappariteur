import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:surappariteur/vue/kuabo/kuabovue.dart';

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
        const Locale('fr', ''), // Français
        const Locale('en', ''), // Anglais (si nécessaire)
      ],
      debugShowCheckedModeBanner: false,
      title: 'Appariteur',
      home: Kuabo(),
      // Créez une instance de SplashScreen
    );
  }
}
