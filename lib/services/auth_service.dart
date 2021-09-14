import 'package:firebase_auth/firebase_auth.dart';

import '../models/exceptions/auth_exceptions/auth_exception.dart';
import '../models/exceptions/auth_exceptions/email_in_use_exception.dart';
import '../models/exceptions/auth_exceptions/password_too_weak_exception.dart';
import '../models/exceptions/auth_exceptions/user_not_found_exception.dart';
import '../models/exceptions/auth_exceptions/user_not_verified_exception.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get userStream {
    return _auth.userChanges();
  }

  // sign in with email and password
  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw UserNotFoundException();
    } catch (e) {
      throw AuthException();
    }
    User user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      //throw UserNotVerifiedException();
      await user.sendEmailVerification();
    }
  }

  //register with email and password
  Future<void> register(String email, String password) async {
    print('email: $email password: $password');
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
