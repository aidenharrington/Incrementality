import 'package:flutter/material.dart';

class FitnessTopBar {
  static final appBar = AppBar(
    title: Text('Tasks'),
    actions: [
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.person),
        onPressed: () {},
      ),
    ],
  );
}
