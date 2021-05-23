import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/navigation_bar.dart';
import '../widgets/placeholder_widget.dart';

class FitnessScreen extends StatelessWidget {
  static const routeName = '/fitness';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness'),
      ),
      body: PlaceholderWidget(),
      bottomNavigationBar: NavigationBar(2),
    );
  }
}
