import 'package:flutter/material.dart';
import 'package:incrementality/screens/fitness_screen.dart';
import 'package:incrementality/screens/study_screen.dart';

import './tasks_screen.dart';
import './profile_screen.dart';
import '../widgets/app_bars/fitness_top_bar.dart';
import '../widgets/app_bars/profile_top_bar.dart';
import '../widgets/app_bars/study_top_bar.dart';
import '../widgets/app_bars/tasks_top_bar.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;

  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': TasksScreen(),
        'title': 'Tasks',
        'appBar': TasksTopBar.appBar,
      },
      {
        'page': StudyScreen(),
        'title': 'Study',
        'appBar': StudyTopBar.appBar,
      },
      {
        'page': FitnessScreen(),
        'title': 'Fitness',
        'appBar': FitnessTopBar.appBar,
      },
      {
        'page': ProfileScreen(),
        'title': 'Profile',
        'appBar': ProfileTopBar.appBar
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _pages[_selectedPageIndex]['appBar'],
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
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
      ),
    );
  }
}
