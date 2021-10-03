import 'package:flutter/material.dart';
import 'package:incrementality/models/exceptions/auth_exceptions/auth_exception.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final String _registrationErrorTitle = 'Error while registering account.';
  final String _signInErrorTitle = 'Error while signing in.';
  final String _registerText = 'New user? Create a new account.';
  final String _signInText = 'Already have an account? Sign in.';

  bool _registrationMode = false;

  String? _emptyFieldValidator(String? value, String field) {
    if (value == null || value.isEmpty) {
      return 'Please enter a $field';
    }
    return null;
  }

  String? _confimPasswordValidator(String? value) {
    String? emptyValidator =
        _emptyFieldValidator(value, 'confirmation password');
    if (emptyValidator != null) {
      return emptyValidator;
    }
    if (_registrationMode &&
        _passwordController.text != _confirmPasswordController.text) {
      return 'Passwords must match.';
    }
    return '';
  }

  void _toggleRegistrationMode() {
    setState(() {
      _registrationMode = !_registrationMode;
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  Future<void> _showErrorAlert(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRegisteredAlert(bool registered) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Status'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                registered
                    ? Text(
                        'You have been successfully registered, please confirm email to continue')
                    : Text('Error registering account'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider _auth =
        Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Sign in to IncreMentality'),
        elevation: 0.0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              validator: (value) => _emptyFieldValidator(value, 'username'),
            ),
            TextFormField(
              //TODO: obfuscate
              controller: _passwordController,
              validator: (value) => _emptyFieldValidator(value, 'password'),
            ),
            _registrationMode
                ? Column(
                    children: [
                      TextFormField(
                        //TODO: obfuscate
                        controller: _confirmPasswordController,
                        validator: (value) => _confimPasswordValidator(value),
                      ),
                      TextButton(
                        onPressed: _toggleRegistrationMode,
                        child: Text(_signInText),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 50,
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.white;
                                }
                                return Theme.of(context).accentColor;
                              },
                            ),
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() != null) {
                              try {
                                bool registered = await _auth.register(
                                  _usernameController.text,
                                  _passwordController.text,
                                );
                                _showRegisteredAlert(registered);
                              } on AuthException catch (e) {
                                await _showErrorAlert(
                                    _registrationErrorTitle, e.message);
                              } catch (e) {
                                await _showErrorAlert(_registrationErrorTitle,
                                    'Unknown System Error');
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      TextButton(
                        onPressed: _toggleRegistrationMode,
                        child: Text(_registerText),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 50,
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.white;
                                }
                                return Theme.of(context).accentColor;
                              },
                            ),
                          ),
                          child: Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() != null) {
                              try {
                                await _auth.signIn(
                                  _usernameController.text,
                                  _passwordController.text,
                                );
                              } on AuthException catch (e) {
                                await _showErrorAlert(
                                    _signInErrorTitle, e.message);
                              } catch (e) {
                                await _showErrorAlert(
                                  _signInErrorTitle,
                                  'Unknown System Error',
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
