import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../models/exceptions/auth_exceptions/auth_exception.dart';
import '../../models/exceptions/auth_exceptions/email_in_use_exception.dart';
import '../../models/exceptions/auth_exceptions/password_too_weak_exception.dart';
import '../../models/exceptions/auth_exceptions/user_not_found_exception.dart';
import '../../models/exceptions/auth_exceptions/user_not_verified_exception.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth firebaseAuth;

  late User? _user;
  bool authenticated = false;

  AuthProvider(this.firebaseAuth);

  User? get user {
    return _user;
  }

  bool get isAuthenticated {
    return authenticated;
  }

  // sign in with email and password
  Future<void> signIn(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw UserNotFoundException();
    } catch (e) {
      throw AuthException();
    }
    User? user = firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      throw UserNotVerifiedException();
    } else {
      print('Signed in...');
      _user = user;
      authenticated = true;
    }
    notifyListeners();
  }

  //register with email and password
  Future<bool> register(String email, String password) async {
    print('email: $email password: $password');
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await firebaseAuth.currentUser?.sendEmailVerification();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailInUseException();
      } else if (e.code == 'weak-password') {
        throw PasswordTooWeakException();
      }
    } catch (e) {
      throw AuthException();
    }
    notifyListeners();
    return true;
  }

  //sign out
  Future<void> signOut() async {
    await firebaseAuth.signOut();
    authenticated = false;
    notifyListeners();
  }
}
