import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_task_screen.dart';
import '../widgets/tasks/task_lists.dart';
import '../widgets/navigation_bar.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final taskProvider = Provider.of<TaskProvider>(context);
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
