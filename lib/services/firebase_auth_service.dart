import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import '../../models/exceptions/auth_exceptions/auth_exception.dart';
import '../../models/exceptions/auth_exceptions/email_in_use_exception.dart';
import '../../models/exceptions/auth_exceptions/password_too_weak_exception.dart';
import '../../models/exceptions/auth_exceptions/user_not_found_exception.dart';
import '../../models/exceptions/auth_exceptions/user_not_verified_exception.dart';

class dep_FirebaseAuthService {
  FirebaseAuth _firebaseAuth;

  dep_FirebaseAuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth =
            firebaseAuth != null ? firebaseAuth : FirebaseAuth.instance;

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

  Stream<AppUser?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<AppUser?> register(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailInUseException();
      } else if (e.code == 'weak-password') {
        throw PasswordTooWeakException();
      }
    } catch (e) {
      throw AuthException();
    }
    return _userFromFirebase(_firebaseAuth.currentUser);
  }

  Future<AppUser?> signInWithEmail(String email, String password) async {
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
      return _userFromFirebase(user);
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
