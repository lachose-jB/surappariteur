import 'package:flutter/material.dart';
import 'package:surappariteur/vue/kuabo/addon/child.dart';

class BoddyD extends StatefulWidget {
  static String routeName = "/kuabo";
  const BoddyD({super.key});

  @override
  State<BoddyD> createState() => _BoddyDState();
}

class _BoddyDState extends State<BoddyD> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: KuaboChild(),
    );
  }
}
