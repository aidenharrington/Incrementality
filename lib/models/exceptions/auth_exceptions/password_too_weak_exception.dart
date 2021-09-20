import './auth_exception.dart';

class PasswordTooWeakException implements AuthException {
  String get message {
    return 'Password is too weak.';
  }
}
