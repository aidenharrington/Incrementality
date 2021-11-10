import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:incrementality/models/app_user.dart';
import 'package:incrementality/models/task.dart';
import 'package:incrementality/services/providers/task_provider.dart';
import 'package:test/test.dart';

void main() {
  final userOne =
      AppUser(uid: '1', email: 'testOne@gmail.com', displayName: 'user_one');

  final userTwo =
      AppUser(uid: '2', email: 'testTwo@gmail.com', displayName: 'user_two');

  final taskOne = Task(
    DateTime.now().toString(),
    'task_one',
    DateTime.now(),
    DateTime.now(),
  );

  final taskTwo = Task(
    DateTime.now().toString(),
    'task_two',
    DateTime.now(),
    DateTime.now(),
  );

  Future<String> addTaskToFirestore(
      FirebaseFirestore firestore, AppUser user, Task task) async {
    DocumentReference doc = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .add({
      'name': task.name,
      'createdAt': task.createdAt,
      'dueDate': task.dueDate,
      'description': task.description,
      'completedAt': task.completedAt,
    });

    return doc.id;
  }

  test('update with null user produces no tasks', () async {
    final firestore = FakeFirebaseFirestore();
    await addTaskToFirestore(firestore, userOne, taskOne);

    TaskProvider taskProvider = TaskProvider();
    taskProvider.update(null, firebaseFirestore: firestore);
    List<Task> taskList = await taskProvider.activeTasks;

    expect(taskList.length, 0);
  });

  test('update changes user', () async {
    final firestore = FakeFirebaseFirestore();
    await addTaskToFirestore(firestore, userTwo, taskOne);

    TaskProvider taskProvider = TaskProvider();
    taskProvider.update(userOne, firebaseFirestore: firestore);
    taskProvider.update(userTwo, firebaseFirestore: firestore);
    List<Task> taskList = await taskProvider.activeTasks;

    expect(taskList.length, 1);
  });

  test('get active tasks', () async {
    final firestore = FakeFirebaseFirestore();
    await addTaskToFirestore(firestore, userOne, taskOne);
    await addTaskToFirestore(firestore, userOne, taskTwo);

    TaskProvider taskProvider = TaskProvider();
    taskProvider.update(userOne, firebaseFirestore: firestore);
    List<Task> taskList = await taskProvider.activeTasks;

    expect(taskList.length, 2);
  });

  test('get task by id', () async {
    final firestore = FakeFirebaseFirestore();
    String idOne = await addTaskToFirestore(firestore, userOne, taskOne);
    String idTwo = await addTaskToFirestore(firestore, userOne, taskTwo);

    TaskProvider taskProvider = TaskProvider();
    taskProvider.update(userOne, firebaseFirestore: firestore);
    Task task = await taskProvider.getTaskById(idOne);

    expect(task.name, taskOne.name);
  });

  test('add task', () async {
    final firestore = FakeFirebaseFirestore();
    String idOne = await addTaskToFirestore(firestore, userOne, taskOne);

    TaskProvider taskProvider = TaskProvider();
    taskProvider.update(userOne, firebaseFirestore: firestore);
    await taskProvider.addTask(taskTwo);
    List<Task> taskList = await taskProvider.activeTasks;

    expect(taskList.length, 2);
  });

  test('update task', () async {
    final firestore = FakeFirebaseFirestore();
    String idOne = await addTaskToFirestore(firestore, userOne, taskOne);

    TaskProvider taskProvider = TaskProvider();
    taskProvider.update(userOne, firebaseFirestore: firestore);
    Task updatedTask = taskTwo;
    String updatedName = 'task_two_updated';
    updatedTask.name = updatedName;
    taskProvider.updateTask(idOne, updatedTask);
    List<Task> taskList = await taskProvider.activeTasks;

    expect(taskList[0].name, updatedName);
  });

  test('delete task', () async {
    final firestore = FakeFirebaseFirestore();
    String idOne = await addTaskToFirestore(firestore, userOne, taskOne);

    TaskProvider taskProvider = TaskProvider();
    taskProvider.update(userOne, firebaseFirestore: firestore);
    taskProvider.deleteTask(idOne);
    List<Task> taskList = await taskProvider.activeTasks;

    expect(taskList.length, 0);
  });

  test('complete task', () async {
    final firestore = FakeFirebaseFirestore();
    String idOne = await addTaskToFirestore(firestore, userOne, taskOne);

    TaskProvider taskProvider = TaskProvider();
    taskProvider.update(userOne, firebaseFirestore: firestore);
    taskProvider.completeTask(idOne);
    List<Task> taskList = await taskProvider.activeTasks;

    expect(taskList.length, 0);
  });
}
