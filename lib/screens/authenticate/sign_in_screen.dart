import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class SignInScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Sign in to IncreMentality'),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 50,
        ),
        child: TextButton(
          child: Text('Sign in'),
          onPressed: () async {},
        ),
      ),
    );
  }
}
