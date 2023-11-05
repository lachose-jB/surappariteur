import 'package:flutter/widgets.dart';
import 'package:surappariteur/vue/home/homevue.dart';
import 'package:surappariteur/vue/kuabo/kuabovue.dart';
import 'package:surappariteur/vue/login/loginvue.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  Kuabo.routeName: (context) => const Kuabo(),
  LoginVue.routeName: (context) => const LoginVue(),
  HomeScreen.routeName: (context) => const HomeScreen(),
};
