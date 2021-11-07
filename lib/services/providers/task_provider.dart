import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/app_user.dart';
import '../../models/task.dart';

class TaskProvider with ChangeNotifier {
  late FirebaseFirestore _firebaseFirestore;
  String? _uid;

  List<Task> _tasks = [];

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
    if (_uid == null) {
      return;
    }

    QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
        .collection('users')
        .doc(_uid)
        .collection('tasks')
        .where('completedAt', isNull: true)
        .orderBy('dueDate', descending: false)
        .get();

    List<QueryDocumentSnapshot> taskDocs = snapshot.docs;

    _tasks = _formatTasks(taskDocs);
  }

  List<Task> _formatTasks(List<QueryDocumentSnapshot> taskDocs) {
    List<Task> tasks = [];

    for (var doc in taskDocs) {
      if (doc.data() != null) {
        Task task = _formatTask(doc);
        tasks.add(task);
      }
    }

    return tasks;
  }

  Task _formatTask(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    String id = doc.reference.id;
    String name = data['name'];
    DateTime createdAt = _timeStampToDateTime(data['createdAt']);
    DateTime dueDate = _timeStampToDateTime(data['dueDate']);
    String? description = data['description'];
    DateTime? completedAt = data['completedAt'] != null
        ? _timeStampToDateTime(data['completedAt'])
        : null;

    Task task = Task(id, name, createdAt, dueDate, description, completedAt);

    return task;
  }

  DateTime _timeStampToDateTime(Timestamp timestamp) {
    return DateTime.parse(timestamp.toDate().toString());
  }

  int get taskCount {
    return _tasks.length;
  }

  Future<Task> getTaskById(String id) async {
    _updateActiveTasks();
    DocumentSnapshot<Map<String, dynamic>> doc = await _firebaseFirestore
        .collection('users')
        .doc(_uid)
        .collection('tasks')
        .doc(id)
        .get();

    Task task = _formatTask(doc);

    return task;
  }

  Future<void> addTask(Task task) async {
    if (_uid == null) {
      return;
    }

    await _firebaseFirestore
        .collection('users')
        .doc(_uid)
        .collection('tasks')
        .add({
      'name': task.name,
      'createdAt': task.createdAt,
      'dueDate': task.dueDate,
      'description': task.description,
      'completedAt': task.completedAt,
    }).catchError((error) => throw error);

    _updateActiveTasks();
    notifyListeners();
  }

  Future<void> updateTask(String id, Task updatedTask) async {
    if (_uid == null) {
      return;
    }

    await _firebaseFirestore
        .collection('users')
        .doc(_uid)
        .collection('tasks')
        .doc(id)
        .update({
      'name': updatedTask.name,
      'createdAt': updatedTask.createdAt,
      'dueDate': updatedTask.dueDate,
      'description': updatedTask.description,
      'completedAt': updatedTask.completedAt,
    }).catchError((error) => throw error);

    _updateActiveTasks();
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    if (_uid == null) {
      return;
    }

    await _firebaseFirestore
        .collection('users')
        .doc(_uid)
        .collection('tasks')
        .doc(id)
        .update({
      'completedAt': DateTime.now(),
      'isDeleted': true,
    }).catchError((error) => throw error);

    _updateActiveTasks();
    notifyListeners();
  }

  Future<void> completeTask(String id) async {
    if (_uid == null) {
      return;
    }

    await _firebaseFirestore
        .collection('users')
        .doc(_uid)
        .collection('tasks')
        .doc(id)
        .update({
      'completedAt': DateTime.now(),
    }).catchError((error) => throw error);

    _updateActiveTasks();
    notifyListeners();
  }
}
