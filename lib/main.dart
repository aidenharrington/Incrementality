import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:incrementality/screens/sign_in_screen.dart';
import 'package:incrementality/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import './helpers/fade_route.dart';
import './providers/task_provider.dart';
import 'screens/tabs/discover_screen.dart';
import 'screens/tabs/edit_task_screen.dart';
import 'screens/tabs/fitness_screen.dart';
import 'screens/tabs/profile_screen.dart';
import 'screens/tabs/study_screen.dart';
import 'screens/tabs/tasks_screen.dart';
import 'screens/generic/app_loading_screen.dart';
import 'screens/generic/error_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (ctx) => AuthProvider(),
              ),
              ChangeNotifierProvider(
                create: (ctx) => TaskProvider(),
              ),
            ],
            child: Consumer<AuthProvider>(
              builder: (ctx, auth, _) => MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.lightBlue,
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: FadeTransitionBuilder(),
                    TargetPlatform.iOS: FadeTransitionBuilder(),
                  }),
                ),
                home: auth.isAuthenticated ? TasksScreen() : SignInScreen(),
                routes: {
                  TasksScreen.routeName: (ctx) => TasksScreen(),
                  DiscoverScreen.routeName: (ctx) => DiscoverScreen(),
                  EditTaskScreen.routeName: (ctx) => EditTaskScreen(),
                  FitnessScreen.routeName: (ctx) => FitnessScreen(),
                  ProfileScreen.routeName: (ctx) => ProfileScreen(),
                  StudyScreen.routeName: (ctx) => StudyScreen(),
                },
                onGenerateRoute: (settings) {
                  //return MaterialPageRoute(builder: (ctx) => WrapperScreen());
                },
                onUnknownRoute: (settings) {
                  //return MaterialPageRoute(builder: (ctx) => WrapperScreen());
                },
              ),
            ),
          );
        }

        return AppLoadingScreen();
      },
    );
  }
}
