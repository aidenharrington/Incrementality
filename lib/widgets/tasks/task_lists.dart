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
      return !_isSameDay(tasks[index].dueDate, tasks[index - 1].dueDate);
    } else {
      return true;
    }
  }

  bool _isSameDay(DateTime dayOne, DateTime dayTwo) {
    return dayOne.day == dayTwo.day &&
        dayOne.month == dayTwo.month &&
        dayOne.year == dayTwo.year;
  }

  bool _isDateInPast(DateTime day) {
    DateTime today = DateTime.now();
    return day.isBefore(today) && !_isSameDay(day, today);
  }

  Widget _showDateAndWidget(Task task) {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));
    String dateText;
    bool taskOverdue = _isDateInPast(task.dueDate);

    if (_isSameDay(task.dueDate, today)) {
      dateText = 'Today';
    } else if (_isSameDay(task.dueDate, tomorrow)) {
      dateText = 'Tomorrow';
    } else {
      dateText = DateFormat.yMMMd().format(task.dueDate);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(
            dateText,
            style: TextStyle(
              color: taskOverdue ? Colors.red : Colors.black,
            ),
          ),
        ),
        TaskItem(task),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
        future: Provider.of<TaskProvider>(context).activeTasks,
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            List<Task>? tasks = snapshot.data;

            return tasks == null || tasks.isEmpty
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

          return Text('Loading');
        });
  }
}
