import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ignore: non_constant_identifier_names
  Future<User?> SignUpWithEmailAndPassword(
      String email, String password, String firstName,String lastname,String confirm,String phoneNumber,String birthDate) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      if (kDebugMode) {
        print("some error occured");
      }
    }
    return null;
  }

  // ignore: non_constant_identifier_names
  Future<User?> SignInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      if (kDebugMode) {
        print("some error occured");
      }
    }
    return null;
  }
}
