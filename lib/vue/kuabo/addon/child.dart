import 'package:flutter/material.dart';
import 'package:surappariteur/vue/kuabo/addon/containt.dart';
import 'package:surappariteur/vue/login/loginvue.dart';

import '../../../addonglobal/constants.dart';
import '../../../addonglobal/default_button.dart';
import '../../../addonglobal/size_config.dart';

class KuaboChild extends StatefulWidget {
  const KuaboChild({super.key});
  @override
  KuaboChildState createState() => KuaboChildState();
}

class KuaboChildState extends State<KuaboChild> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Bienvenue Chez Appariteur!",
      "image": "assets/images/splash_1.png"
    },
    {
      "text":
          "Surveillance de vos examens et concours En ligne et \n en présentielle partout en France",
      "image": "assets/images/splash_2.png"
    },
    {
      "text":
          "Vous souhaitez surveiller des épreuvesde concours \nou d'examens en Ile-de-France",
      "image": "assets/images/splash_3.png"
    },
  ];

  bool get isLastPage => currentPage == splashData.length - 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => KuaboContaint(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => AnimatedContainer(
                          duration: kAnimationDuration,
                          margin: const EdgeInsets.only(right: 5),
                          height: 6,
                          width: currentPage == index ? 20 : 6,
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? kPrimaryColor
                                : const Color(0xFFD8D8D8),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 3),
                    DefaultButton(
                      text: isLastPage ? "Continuer" : "Suivant",
                      press: () {
                        if (isLastPage) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const LoginVue();
                            }),
                          );
                        } else {}
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
