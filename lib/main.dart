import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:surappariteur/police/helper/serveur/authentificateur.dart';
import 'package:surappariteur/vue/kuabo/kuabovue.dart';
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
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        Locale('fr', ''), // Français
        Locale('en', ''), // Anglais (si nécessaire)
      ],
      debugShowCheckedModeBanner: false,
      title: 'Appariteur',
      home: FutureBuilder(
        // Utilisez un FutureBuilder pour vérifier les SharedPreferences
        future: AuthApi.getTokenFromSharedPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            // Vérifier si le token est présent dans les SharedPreferences
            if (snapshot.hasData && snapshot.data != null) {
              return Kuabo();
            } else {
              return LoginVue();
            }
          }
        },
      ),
      // Créez une instance de SplashScreen
    );
  }
}
