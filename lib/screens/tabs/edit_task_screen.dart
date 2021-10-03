import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';
import '../../providers/task_provider.dart';

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
  late Task _task;
  var _isInit = true;
  var _isLoading = false;
  bool _isNewTask = true;

  void _saveForm() {
    bool? valid = _form.currentState?.validate();
    if (valid == null || !valid) {
      return;
    }
    _form.currentState?.save();
    if (!_isNewTask) {
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
      final String? taskId =
          ModalRoute.of(context)?.settings.arguments as String?;
      if (taskId != null && taskId.isNotEmpty) {
        try {
          _task = Provider.of<TaskProvider>(context, listen: false)
              .findTaskById(taskId);
          setState(() {
            _isNewTask = false;
            _dateController.text = _formatDate(_task.dueDate);
            _timeController.text = _formatTime(_task.dueTime);
          });
        } catch (error) {
          print(error);
        }
      } else {
        setState(() {
          _task = Task(
            DateTime.now().toString(),
            '',
            DateTime.now(),
            DateTime.now(),
            TimeOfDay.now(),
          );
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
    _isInit = false;
    super.didChangeDependencies();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
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
    final TimeOfDay? picked = await showTimePicker(
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
        title: Text(_task.name),
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
                      initialValue: _task.name,
                      decoration: InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _task.name = value as String;
                      },
                    ),
                    TextFormField(
                      initialValue: _task.description,
                      decoration: InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.next,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
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
                        if (value == null || value.isEmpty) {
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
                        if (value == null || value.isEmpty) {
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
