import 'package:flutter/material.dart';

import '../../police/vueController/missioncontroler/newMission.dart';


class TopBarS extends StatelessWidget implements PreferredSizeWidget {
  final int _notificationCount = 0;
  final VoidCallback onNotificationPressed;
  String PageName = "";
  final TabController? tabController;

  TopBarS(
      {super.key, required this.onNotificationPressed, required this.PageName, this.tabController});

  int get notificationCount => _notificationCount;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      title: Text(
        PageName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      automaticallyImplyLeading: false, // Désactive le bouton de retour
      actions: <Widget>[
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: onNotificationPressed,
            ),
            if (_notificationCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    _notificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ],
      bottom: tabController != null ? TabBar(
        controller: tabController,
        tabs: [
          Tab(text: 'Missions effectuées'),
          Tab(text: 'Missions à venir'),
        ],
      ) : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


