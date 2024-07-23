import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// enum SignInResult {
//   success,
//   userNotFound,
//   wrongPassword,
//   failed,
// }

// enum SignUpResult {
//   success,
//   emailAlreadyExist,
//   invalidEmail,
//   weakPassword,
//   failed,
// }

class ApalahProvider extends ChangeNotifier {
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  set setErrorMessage(String message) {
    _errorMessage = message;
  }

  Future<void> signIn(String email, String password) async {
    _errorMessage = '';
    notifyListeners();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errorMessage = 'Pastikan anda memasukkan akun dengan benar!';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Pastikan anda memasukkan akun dengan benar!';
      } else {
        _errorMessage = 'Terjadi kesalahan: ${e.message}';
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan tidak terduga: $e';
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    _errorMessage = '';
    notifyListeners();

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Handle the error
      if (e is FirebaseAuthException) {
        // Firebase Authentication error
        if (e.code == 'email-already-in-use') {
          _errorMessage = 'Email sudah digunakan';
        } else if (e.code == 'invalid-email') {
          _errorMessage = 'Gunakan email yang benar';
        } else if (e.code == 'weak-password') {
          _errorMessage = 'Password lemah';
        } else {
          _errorMessage = 'Terjadi kesalahan: ${e.message}';
        }
        notifyListeners();
      } else {
        _errorMessage = 'Terjadi kesalahan tidak terduga: $e';
        notifyListeners();
      }
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
