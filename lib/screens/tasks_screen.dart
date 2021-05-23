import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/navigation_bar.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('IncreMentality'),
      ),
      body: taskProvider.tasks.isEmpty
          ? Container(
              child: Text('No Tasks'),
            )
          : ListView(),
      bottomNavigationBar: NavigationBar(0),
    );
  }
}
