import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import 'task_item.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).tasks;
    return tasks.isEmpty
        ? Container(
            child: Center(
              child: Text(
                'No tasks yet.',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : ListView(
            children: tasks
                .map((task) => TaskItem(
                      task.id,
                      task.name,
                    ))
                .toList(),
          );
  }
}
