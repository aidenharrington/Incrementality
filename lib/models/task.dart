class Task {
  final String id;
  String name;
  DateTime createdAt;
  String description;
  DateTime completedAt;
  DateTime dueDateTime;

  Task(this.id, this.name, this.createdAt,
      [this.description, this.completedAt, this.dueDateTime]);
}
