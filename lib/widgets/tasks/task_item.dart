import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final String name;

  TaskItem(this.name);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(name),
      ),
    );
  }
}
