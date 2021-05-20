import 'package:flutter/material.dart';

class StudyTopBar {
  static final appBar = AppBar(
    title: Text('Study'),
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
