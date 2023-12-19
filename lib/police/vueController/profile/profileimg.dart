import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helper/serveur/authentificateur.dart';

class ProfileImg extends StatelessWidget {

  const ProfileImg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final userData = AuthApi.getLoggedUserData();

    if (userData != null) {
      return CircleAvatar(
        radius: 65,
        backgroundImage:
        Image.network("https://appariteur.com/admins/user_images/"+userData.image,fit: BoxFit.cover,).image,
        //backgroundImage: AssetImage("assets/images/logo.jpg"),
      );
    } else {
      return const CircleAvatar(
        backgroundImage: AssetImage("assets/images/logo.jpg"),
      );
    }

  }

}