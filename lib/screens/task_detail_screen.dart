import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskDetailScreen extends StatelessWidget {
  static const routeName = '/task-detail-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Placeholder'),
      ),
      body: Container(
        child: Text('This task'),
      ),
    );
  }
}
