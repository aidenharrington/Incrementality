import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return taskProvider.tasks.isEmpty
        ? Container(
            child: Text('No Tasks'),
          )
        : ListView();
  }
}
