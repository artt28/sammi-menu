import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';

class CommonBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CommonBottomNavBar({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          label: '',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      iconSize: 30,
      onTap: (index) {
        if (index == 0 && currentIndex != 0) {
          context.go(SGRoute.welCome.route);
        } else if (index == 1 && currentIndex != 1) {
          context.go(SGRoute.menu.route);
        } else if (index == 2 && currentIndex != 2) {
          context.go(SGRoute.promotion.route);
        }
      },
    );
  }
}
