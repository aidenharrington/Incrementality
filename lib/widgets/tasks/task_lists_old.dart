import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';
import '../../services/providers/task_provider.dart';
import 'task_item.dart';

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  bool _newDate(List<Task> tasks, int index) {
    if (index > 0) {
      if (tasks[index].dueDate != tasks[index - 1].dueDate) {
        return true;
      } else {
        return false;
      }
    } else {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (tasks[index].dueDate != today) {
        return true;
      }
    }
    return false;
  }

  Widget _showDateAndWidget(Task task) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(DateFormat.yMMMd().format(task.dueDate)),
        ),
        TaskItem(task),
      ],
    );
  }

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
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (ctx, i) {
              return _newDate(tasks, i)
                  ? _showDateAndWidget(tasks[i])
                  : TaskItem(tasks[i]);
            });
  }
}
