import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class EditTaskScreen extends StatefulWidget {
  static const routeName = '/edit-task-screen';

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _form = GlobalKey<FormState>();
  var _task = Task(
    null,
    '',
  );
  var _initValues = {
    'name': '',
  };
  var _isInit = true;
  var _isLoading = false;

  void _saveForm() {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    if (_task.id != null) {
      Provider.of<TaskProvider>(context, listen: false)
          .updateTask(_task.id, _task);
    } else {
      Provider.of<TaskProvider>(context, listen: false).addTask(_task);
    }
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final taskId = ModalRoute.of(context).settings.arguments as String;
      if (taskId != null) {
        try {
          _task = Provider.of<TaskProvider>(context, listen: false)
              .findTaskById(taskId);
          _initValues = {
            'name': _task.name,
          };
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not load task.'),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Placeholder'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['name'],
                decoration: InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _task.name = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
