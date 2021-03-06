import 'package:flutter/material.dart';

import './edit_task_screen.dart';
import '../../widgets/tasks/task_lists.dart';
import '../../widgets/navigation_bar.dart';

class TasksScreen extends StatelessWidget {
  static const routeName = "/tasks";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IncreMentality'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditTaskScreen.routeName);
            },
          ),
        ],
      ),
      body: TasksList(),
      bottomNavigationBar: NavigationBar(0),
    );
  }
}
