import 'package:flutter/material.dart';

class Task {
  final String id;
  String name;
  DateTime createdAt;
  String description;
  DateTime completedAt;
  DateTime dueDate;
  TimeOfDay dueTime;

  Task(
    this.id,
    this.name,
    this.createdAt, [
    this.description,
    this.completedAt,
    this.dueDate,
    this.dueTime,
  ]);
}
