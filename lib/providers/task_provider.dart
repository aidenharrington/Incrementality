import 'package:flutter/foundation.dart';

import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks {
    return [..._tasks];
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String name) {
    _tasks.add(
      Task(
        DateTime.now().toString(),
        name,
      ),
    );
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
