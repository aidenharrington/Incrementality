import './auth_exception.dart';

class UserNotVerifiedException implements AuthException {
  String get message {
    return 'Please verify your email before continuing.';
  }
}
