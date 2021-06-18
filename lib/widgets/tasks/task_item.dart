import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import '../../screens/edit_task_screen.dart';

class TaskItem extends StatelessWidget {
  final String id;
  final String name;

  TaskItem(this.id, this.name);

  void completeTask(BuildContext context) {
    try {
      Provider.of<TaskProvider>(context, listen: false).completeTask(id);
      showSnackBar('$name completed.', context);
    } catch (error) {
      showSnackBar('Completing task failed.', context);
    }
  }

  void editTask(BuildContext context) {
    Navigator.of(context).pushNamed(EditTaskScreen.routeName, arguments: id);
  }

  void deleteTask(BuildContext context) {
    try {
      Provider.of<TaskProvider>(context, listen: false).deleteTask(id);
      showSnackBar('$name deleted.', context);
    } catch (error) {
      showSnackBar('Deletion Failed.', context);
    }
  }

  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Future<bool> showCustomAlertDialog(
      String title, String content, BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.green,
        child: Icon(Icons.check, color: Colors.white),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {
          return showCustomAlertDialog(
              'Are you sure', 'Complete task', context);
        } else {
          return showCustomAlertDialog('Are you sure', 'Delete task', context);
        }
      },
      onDismissed: (direction) {
        direction == DismissDirection.startToEnd
            ? completeTask(context)
            : deleteTask(context);
      },
      child: Card(
        elevation: 5,
        child: ListTile(
          title: Text(name),
          trailing: Container(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    completeTask(context);
                  },
                  color: Colors.green,
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    editTask(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteTask(context);
                  },
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
