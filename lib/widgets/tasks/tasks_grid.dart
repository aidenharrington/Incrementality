import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import './task_item.dart';

class TasksGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).tasks;
    return ListView(
      children: tasks
          .map((task) => TaskItem(
                task.name,
              ))
          .toList(),
    );
  }
}
