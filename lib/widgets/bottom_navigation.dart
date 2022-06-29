import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:doc_side_appoinment/screens/main_screen_home/main_home_screen.dart';
import 'package:flutter/material.dart';

class NewBottomNavigationBar extends StatelessWidget {
  const NewBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MainHomeScreen.selectedIndexNotifier,
      builder: (BuildContext ctx, int updatedIndex, Widget? _) {
        return BottomNavyBar(
          selectedIndex: updatedIndex,
          onItemSelected: (index) {
            MainHomeScreen.selectedIndexNotifier.value = index;
           },
          items: [
            BottomNavyBarItem(
              icon: const Icon(
                Icons.home_outlined,
                size: 26,
              ),
              title: const Text('Home'),
              textAlign: TextAlign.center,
              activeColor: Colors.blueAccent.shade700,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.people_alt_outlined),
              title: const Text('Patients'),
              textAlign: TextAlign.center,
              activeColor: Colors.blueAccent.shade700,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              textAlign: TextAlign.center,
              activeColor: Colors.blueAccent.shade700,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.apps_outlined),
              title: const Text('More'),
              textAlign: TextAlign.center,
              activeColor: Colors.blueAccent.shade700,
              inactiveColor: Colors.grey,
            ),
          ],
        );
      },
    );
  }
}
