import 'package:flutter/material.dart';

class Task {
  final String id;
  String name;
  DateTime createdAt;
  DateTime dueDate;
  String? description;
  DateTime? completedAt;

  Task(
    this.id,
    this.name,
    this.createdAt,
    this.dueDate, [
    this.description,
    this.completedAt,
  ]);
}
