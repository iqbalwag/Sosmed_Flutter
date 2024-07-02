import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum SignInResult {
  success,
  userNotFound,
  wrongPassword,
  failed,
}

enum SignUpResult {
  success,
  emailAlreadyExist,
  invalidEmail,
  weakPassword,
  failed,
}

class ApalahProvider extends ChangeNotifier {
  Future<SignInResult> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return SignInResult.success;
    } catch (e) {
      // Handle the error
      if (e is FirebaseAuthException) {
        // Firebase Authentication error
        if (e.code == 'user-not-found') {
          return SignInResult.userNotFound;
        } else if (e.code == 'wrong-password') {
          return SignInResult.wrongPassword;
        } else {
          return SignInResult.failed;
        }
      } else {
        print('An unexpected error occurred: $e');
        return SignInResult.wrongPassword;
      }
    }
  }

  Future<SignUpResult> signUp(String email, String password) async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        return SignUpResult.success;
      } catch (e) {
      // Handle the error
      if (e is FirebaseAuthException) {
        // Firebase Authentication error
        if (e.code == 'email-already-in-use') {
          return SignUpResult.emailAlreadyExist;
        } else if (e.code == 'invalid-email') {
          return SignUpResult.invalidEmail;
        } else if (e.code == 'weak-password') {
          return SignUpResult.weakPassword;
        } else {
          return SignUpResult.failed;
        }
      } else {
        print('An unexpected error occurred: $e');
        return SignUpResult.failed;
      }
    }
  }
  
  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}