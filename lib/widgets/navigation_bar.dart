import 'package:flutter/material.dart';

import '../screens/fitness_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/study_screen.dart';

class NavigationBar extends StatelessWidget {
  List<String> pageRoutes = [
    '/',
    StudyScreen.routeName,
    FitnessScreen.routeName,
    ProfileScreen.routeName,
  ];
  final int selectedPageIndex;

  NavigationBar(this.selectedPageIndex);

  @override
  Widget build(BuildContext context) {
    void selectPage(int index) {
      Navigator.of(context).pushReplacementNamed(pageRoutes[index]);
    }

    return BottomNavigationBar(
      onTap: selectPage,
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.black,
      currentIndex: selectedPageIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.border_color),
          label: 'Study',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Fitness',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
