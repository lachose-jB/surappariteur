import 'package:flutter/material.dart';
import 'package:surappariteur/police/vueController/loginController/childlogin.dart';

class LoginVue extends StatelessWidget {
  static String routeName = "/loginvue";
  const LoginVue({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Se connecter"),
      ),
      body: const ChildLogin(),
    );
  }
}
