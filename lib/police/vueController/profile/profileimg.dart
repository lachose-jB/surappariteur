import 'package:flutter/material.dart';

class ProfileImg extends StatelessWidget {
  const ProfileImg({
    Key? key,
  });
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/logo.jpg"),
          )
        ],
      ),
    );
  }
}
