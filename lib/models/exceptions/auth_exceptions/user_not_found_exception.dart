import './auth_exception.dart';

class UserNotFoundException implements AuthException {
  String get message {
    return 'Username or password is incorrect. Please try again.';
  }
}
