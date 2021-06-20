import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './helpers/fade_route.dart';
import './providers/task_provider.dart';
import './screens/discover_screen.dart';
import './screens/edit_task_screen.dart';
import './screens/fitness_screen.dart';
import './screens/profile_screen.dart';
import './screens/study_screen.dart';
import './screens/tasks_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => TaskProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.lightBlue,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: FadeTransitionBuilder(),
            TargetPlatform.iOS: FadeTransitionBuilder(),
          }),
        ),
        routes: {
          '/': (ctx) => TasksScreen(),
          DiscoverScreen.routeName: (ctx) => DiscoverScreen(),
          EditTaskScreen.routeName: (ctx) => EditTaskScreen(),
          FitnessScreen.routeName: (ctx) => FitnessScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          StudyScreen.routeName: (ctx) => StudyScreen(),
        },
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => TasksScreen());
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => TasksScreen());
        },
      ),
    );
  }
}
