import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front_sosmed/widgets/auth_button.dart';
import 'package:front_sosmed/widgets/auth_text_field.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

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

  displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ApalahProvider authProvider =
        Provider.of<ApalahProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const Gap(40),
                Text('Selamat datang, di POPO Land',
                    style: TextStyle(color: Colors.grey[700])),
                const Gap(30),
                AuthTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    obscureText: false,
                    color: authProvider.errorMessage.isEmpty
                        ? Colors.white
                        : Colors.red),
                const Gap(10),
                AuthTextField(
                    controller: passwordTextController,
                    hintText: 'Password',
                    obscureText: true,
                    color: authProvider.errorMessage.isEmpty
                        ? Colors.white
                        : Colors.red),
                const Gap(10),
                AuthTextField(
                    controller: repasswordTextController,
                    hintText: 'Tulis ulang Password',
                    obscureText: true,
                    color: authProvider.errorMessage.isEmpty
                        ? Colors.white
                        : Colors.red),
                const Gap(10),
                AuthButton(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      if (passwordTextController.text ==
                          repasswordTextController.text) {
                        await authProvider.signUp(emailTextController.text,
                            passwordTextController.text);
                        setState(() {
                          authProvider.errorMessage;
                        });
                        if (context.mounted) Navigator.pop(context);
                      } else if (passwordTextController.text !=
                          repasswordTextController.text) {
                        Navigator.pop(context);
                        displayMessage("Password tidak sama!");
                        return;
                      }
                    },
                    text: 'Sign Up'),
                const Gap(10),
                authProvider.errorMessage.isEmpty
                    ? LoginText(widget: widget)
                    : Column(
                        children: [
                          Text(
                            authProvider.errorMessage,
                            style: TextStyle(color: Colors.red[900]),
                          ),
                          const Gap(10),
                          LoginText(widget: widget)
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

class LoginText extends StatelessWidget {
  const LoginText({
    super.key,
    required this.widget,
  });

  final RegisterPage widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sudah mempunyai akun ?',
          style: TextStyle(color: Colors.grey[700]),
        ),
        const Gap(7),
        GestureDetector(
            onTap: widget.onTap,
            child: const Text(
              'Masuk Sekarang!',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            )),
      ],
    );
  }
}
