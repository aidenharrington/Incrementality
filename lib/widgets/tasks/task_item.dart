import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text('Task!'),
      ),
    );
  }
}
