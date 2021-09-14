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
      body: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 50,
            ),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                await _auth.register('bob', 'pass');
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 50,
            ),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
              onPressed: () async {},
            ),
          ),
        ],
      ),
    );
  }
}
