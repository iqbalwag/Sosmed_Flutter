import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front_sosmed/widgets/auth_button.dart';
import 'package:front_sosmed/widgets/auth_text_field.dart';
import 'package:gap/gap.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final repasswordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock,size: 100,),
                const Gap(40),
                Text('Welcome, to POPO Land',style: TextStyle(color: Colors.grey[700])),
                const Gap(30),
                AuthTextField(controller: emailTextController, hintText: 'Email', obscureText: false),
                const Gap(10),
                AuthTextField(controller: passwordTextController, hintText: 'Password', obscureText: true),
                const Gap(10),
                AuthTextField(controller: repasswordTextController, hintText: 'Confirm Password', obscureText: true),
                const Gap(10),
                AuthButton(onTap: widget.onTap, text: 'Sign Up'),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have account ?',style: TextStyle(color: Colors.grey[700]),),
                    const Gap(7),
                    GestureDetector(onTap: widget.onTap,child: const Text('Login Now',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}