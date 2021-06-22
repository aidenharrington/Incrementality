import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  var _task = Task(
    null,
    '',
    null,
    null,
    null,
    null,
  );
  var _initValues = {
    'name': '',
    'description': '',
    'dueDate': DateTime.now(),
    'dueTime': TimeOfDay.now(),
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
      _task.createdAt = DateTime.now();
      Provider.of<TaskProvider>(context, listen: false).addTask(_task);
    }
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final taskId = ModalRoute.of(context).settings.arguments as String;
      if (taskId != null) {
        try {
          _task = Provider.of<TaskProvider>(context, listen: false)
              .findTaskById(taskId);
          _initValues = {
            'name': _task.name,
            'description': _task.description,
            // 'dueDate': _formatDate(_task.dueDate),
            // 'dueTime': _formatTime(_task.dueTime),
            'dueDate': _task.dueDate,
            'dueTime': _task.dueTime,
          };
          setState(() {
            _dateController.text = _initValues['dueDate'];
          });
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
    setState(() {
      _isLoading = false;
    });
    _isInit = false;
    super.didChangeDependencies();
  }

  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = _formatTime(picked);
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMd().format(date);
  }

  String _formatTime(TimeOfDay time) {
    return DateFormat.jm().format(
      DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        time.hour,
        time.minute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_initValues['name']),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.next,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _task.description = value;
                      },
                    ),
                    TextFormField(
                      onTap: () => _selectDate(context),
                      onSaved: (value) {
                        _task.dueDate = _selectedDate;
                      },
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: "Date",
                        icon: Icon(Icons.event),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a date for your task";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      onTap: () => _selectTime(context),
                      onSaved: (value) {
                        _task.dueTime = _selectedTime;
                      },
                      controller: _timeController,
                      decoration: InputDecoration(
                        labelText: "Time",
                        icon: Icon(Icons.access_time),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a time for your task";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
