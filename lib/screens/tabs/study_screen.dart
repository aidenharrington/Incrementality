import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/navigation_bar.dart';
import '../widgets/placeholder_widget.dart';

class StudyScreen extends StatelessWidget {
  static const routeName = '/study';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study'),
      ),
      body: PlaceholderWidget(),
      bottomNavigationBar: NavigationBar(2),
    );
  }
}
