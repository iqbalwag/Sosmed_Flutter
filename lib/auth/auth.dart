import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:front_sosmed/auth/login_or_register.dart';
import 'package:front_sosmed/pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //jika user telah login
          if(snapshot.hasData){
            return const HomePage();
          }
          else{
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}