import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/app_user.dart';
import '../../models/task.dart';

class TaskProvider with ChangeNotifier {
  late FirebaseFirestore _firebaseFirestore;
  late String _uid;

  List<Task> _tasks = [];
  List<Task> _completedTasks = [];

  Future<void> update(AppUser? user,
      {FirebaseFirestore? firebaseFirestore}) async {
    final String? uid = user?.uid;
    if (uid != null) {
      firebaseFirestore != null
          ? _firebaseFirestore = firebaseFirestore
          : _firebaseFirestore = FirebaseFirestore.instance;

      _uid = uid;
      await _updateActiveTasks();
    }
  }

  Future<List<Task>> get activeTasks async {
    await _updateActiveTasks();
    return _tasks;
  }

  Future<void> _updateActiveTasks() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
        .collection('users')
        .doc(_uid)
        .collection('tasks')
        .where('completedAt', isNull: false)
        .get();

    //TODO sort by date

    List<QueryDocumentSnapshot> taskDocs = snapshot.docs;

    _tasks = formatTasks(taskDocs);
  }

  List<Task> formatTasks(List<QueryDocumentSnapshot> taskDocs) {
    List<Task> tasks = [];

    for (var doc in taskDocs) {
      if (doc.data() != null) {
        var data = doc.data() as Map<String, dynamic>;
        String id = data['id'];
        String name = data['name'];
        DateTime createdAt = data['createdAt'];
        DateTime dueDate = data['dueDate'];
        String? description = data['description'];
        DateTime? completedAt = data['completedAt'];

        Task task =
            Task(id, name, createdAt, dueDate, description, completedAt);
        tasks.add(task);
      }
    }

    return tasks;
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
