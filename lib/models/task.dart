import 'package:flutter/material.dart';

class Task {
  final String id;
  String name;
  DateTime createdAt;
  DateTime dueDate;
  TimeOfDay dueTime;
  String? description;
  DateTime? completedAt;

  Task(
    this.id,
    this.name,
    this.createdAt,
    this.dueDate,
    this.dueTime, [
    this.description,
    this.completedAt,
  ]);
}
