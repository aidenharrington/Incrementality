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

  test('update changes user', () async {
    final firestore = FakeFirebaseFirestore();
    await addTaskToFirestore(firestore, userTwo, taskOne);

    TaskProvider taskProvider = TaskProvider();
    taskProvider.update(userOne, firebaseFirestore: firestore);
    taskProvider.update(userTwo, firebaseFirestore: firestore);
    List<Task> taskList = await taskProvider.activeTasks;

    expect(taskList.length, 1);
  });
}
