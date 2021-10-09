import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/test.dart';
import 'package:incrementality/services/providers/deprecated_auth_provider.dart';
import 'package:mockito/mockito.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

void main() {
  //Tests

  //isAuthenticated
  test(
      'Given a firebase instance with no users When isAutenticated is called Then return false',
      () async {});

  //sign in good
  test('', () async {
    // final mockAuth = FirebaseAuthMock();
    // when(mockAuth.signInWithEmailAndPassword(email: '', password: ''))
    //     .thenAnswer((realInvocation) => Future.value(''));
  });

  //sign in no user

  //sign in throws general error

  //sign in not verified

  //register good

  //register email in use

  //register password too weak

  //register general error

  //signout
}
