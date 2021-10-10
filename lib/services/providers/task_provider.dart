import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/app_user.dart';
import '../../models/task.dart';

class TaskProvider with ChangeNotifier {
  late FirebaseFirestore _firebaseFirestore;
  late Stream<QuerySnapshot> _tasksStream;

  List<Task> _tasks = [];
  List<Task> _completedTasks = [];

  void update(AppUser? user, {FirebaseFirestore? firebaseFirestore}) {
    final String? uid = user?.uid;
    if (uid != null) {
      firebaseFirestore != null
          ? _firebaseFirestore = firebaseFirestore
          : _firebaseFirestore = FirebaseFirestore.instance;

      _tasksStream = _firebaseFirestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .snapshots();
    }
  }

  Stream<QuerySnapshot> get tasksStream {
    return _tasksStream;
  }

  Future<List<Task>> get tasks {
    //get tasks

    //TODO think of way of handling completed and deleted tasks
  }

  int get taskCount {
    return _tasks.length;
  }

  Task findTaskById(String id) {
    return _tasks.firstWhere(
      (task) => task.id == id,
      orElse: () => throw Exception,
    );
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
