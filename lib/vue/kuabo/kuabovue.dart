import 'package:flutter/material.dart';
import 'package:surappariteur/vue/kuabo/addon/child.dart';
class Kuabo extends StatefulWidget {
  static String routeName = "/kuabo";
  const Kuabo({super.key});

  @override
  State<Kuabo> createState() => _KuaboState();
}

class _KuaboState extends State<Kuabo> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: KuaboChild(),
    );
  }
}
