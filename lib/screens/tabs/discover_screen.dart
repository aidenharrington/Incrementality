import 'package:flutter/material.dart';

import '../../widgets/navigation_bar.dart';
import '../../widgets/placeholder_widget.dart';

class DiscoverScreen extends StatefulWidget {
  static const routeName = '/discover';
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
      ),
      body: PlaceholderWidget(),
      bottomNavigationBar: NavigationBar(1),
    );
  }
}
