import 'package:cloud_firestore/cloud_firestore.dart';
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
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    Stream<QuerySnapshot> tasksStream = taskProvider.tasksStream;

    return StreamBuilder(
      stream: tasksStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['full_name']),
              subtitle: Text(data['company']),
            );
          }).toList(),
        );
      },
    );
  }
}
