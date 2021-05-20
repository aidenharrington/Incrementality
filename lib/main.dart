import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/task_provider.dart';
import './screens/tabs_screen.dart';
import './screens/task_detail_screen.dart';

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
        ),
        routes: {
          '/': (ctx) => TabsScreen(),
          TaskDetailScreen.routeName: (ctx) => TaskDetailScreen(),
        },
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => TabsScreen());
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => TabsScreen());
        },
      ),
    );
  }
}
