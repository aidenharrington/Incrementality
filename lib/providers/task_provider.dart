import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _completedTasks = [];

  List<Task> get tasks {
    return [..._tasks];
  }

  int get taskCount {
    return _tasks.length;
  }

  Task findTaskById(String id) {
    final task = _tasks.firstWhere((task) => task.id == id);
    if (task != null) {
      return task;
    } else {
      throw Exception();
    }
  }

  void addTask(Task task) {
    _tasks.add(task);
    _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    notifyListeners();
  }

  void updateTask(String id, Task newTask) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      _tasks[taskIndex] = newTask;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void completeTask(String id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    _completedTasks.add(_tasks.removeAt(taskIndex));
    notifyListeners();
  }
}
