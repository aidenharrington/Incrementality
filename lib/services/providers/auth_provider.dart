import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../models/app_user.dart';
import '../../models/exceptions/auth_exceptions/auth_exception.dart';
import '../../models/exceptions/auth_exceptions/email_in_use_exception.dart';
import '../../models/exceptions/auth_exceptions/password_too_weak_exception.dart';
import '../../models/exceptions/auth_exceptions/user_not_found_exception.dart';
import '../../models/exceptions/auth_exceptions/user_not_verified_exception.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _firebaseAuth;

  late AppUser? _user;
  bool authenticated = false;

  AuthProvider({FirebaseAuth? firebaseAuth})
      : _firebaseAuth =
            firebaseAuth != null ? firebaseAuth : FirebaseAuth.instance;

  AppUser? get user {
    return _user;
  }

  bool get isAuthenticated {
    return authenticated;
  }

  AppUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      return AppUser(
        uid: user.uid,
        email: user.uid,
        displayName: user.displayName,
      );
    }
  }

  // sign in with email and password
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw UserNotFoundException();
    } catch (e) {
      throw AuthException();
    }
    User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      throw UserNotVerifiedException();
    } else {
      print('Signed in...');
      _user = _userFromFirebase(user);
      authenticated = true;
    }
    notifyListeners();
  }

  //register with email and password
  Future<bool> register(String email, String password) async {
    print('email: $email password: $password');
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firebaseAuth.currentUser?.sendEmailVerification();
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
    await _firebaseAuth.signOut();
    authenticated = false;
    notifyListeners();
  }
}
