import 'package:flutter/material.dart';
import '../../../addonglobal/constants.dart';
import '../../../addonglobal/size_config.dart';

class KuaboContaint extends StatelessWidget {
  const KuaboContaint({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        Text(
          "APPARITEUR",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        Image.asset(
          image!,
          height: getProportionateScreenHeight(365),
          width: getProportionateScreenWidth(335),
        ),
      ],
    );
  }
}
