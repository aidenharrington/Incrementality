import 'package:flutter/material.dart';

import '../../widgets/navigation_bar.dart';
import '../../widgets/placeholder_widget.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: PlaceholderWidget(),
      bottomNavigationBar: NavigationBar(4),
    );
  }
}
