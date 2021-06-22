import 'package:flutter/material.dart';

class Task {
  final String id;
  String name;
  DateTime createdAt;
  String description;
  DateTime dueDate;
  TimeOfDay dueTime;
  DateTime completedAt;

  Task(
    this.id,
    this.name,
    this.createdAt, [
    this.description,
    this.dueDate,
    this.dueTime,
    this.completedAt,
  ]);
}
