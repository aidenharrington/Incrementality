import 'package:incrementality/models/exceptions/auth_exceptions/auth_exception.dart';

class EmailInUseException implements AuthException {
  String get message {
    return 'Email is already in use.';
  }
}
