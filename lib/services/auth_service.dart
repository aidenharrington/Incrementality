import 'package:firebase_auth/firebase_auth.dart';
import 'package:incrementality/models/exceptions/auth_exceptions/user_not_found_exception.dart';

import '../models/exceptions/auth_exceptions/auth_exception.dart';
import '../models/exceptions/auth_exceptions/email_in_use_exception.dart';
import '../models/exceptions/auth_exceptions/password_too_weak_exception.dart';
import '../models/authenticated_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in with email and password
  Future<AuthenticatedUser> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthenticatedUser(uid: 'Placeholder');
    } on FirebaseAuthException catch (e) {
      throw UserNotFoundException();
    } catch (e) {
      throw AuthException();
    }
  }

  //register with email and password
  Future<AuthenticatedUser> register(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthenticatedUser(uid: 'Placeholder');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw PasswordTooWeakException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailInUseException();
      }
    } catch (e) {
      throw AuthException();
    }
  }

  //sign out

}
