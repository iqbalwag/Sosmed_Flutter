import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front_sosmed/widgets/auth_button.dart';
import 'package:front_sosmed/widgets/auth_text_field.dart';
import 'package:front_sosmed/providers/auth_provider.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// enum SignInResult {
//   success,
//   userNotFound,
//   wrongPassword,
//   failed,
// }

class _LoginPageState extends State<LoginPage> {
  late String imageUrl;
  String error = '';
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _downloadImage();
  }

  // errAuth() {
  //   setState(() {
  //     err = !err;
  //   });
  // }

  Future<void> _downloadImage() async {
    try {
      // Referensi ke file gambar di Firebase Storage
      final ref = FirebaseStorage.instance.ref().child('2b-san.jpg');
      // Mendapatkan URL download
      final url = await ref.getDownloadURL();
      setState(() {
        imageUrl = url;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // gambar(String imageFileName) async {
  //   final gsReference = FirebaseStorage.instance
  //       .refFromURL("gs://sosmedproject-e95b1.appspot.com/2b-san.jpg");

  //   final imageUrl = await gsReference.child(imageFileName).getDownloadURL();

  //   return imageUrl;
  // }

  // Future<SignInResult> signIn() async{
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailTextController.text,
  //       password: passwordTextController.text,
  //     );
  //     return SignInResult.success;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //       return SignInResult.userNotFound;
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //       return SignInResult.wrongPassword;
  //     } else {
  //       print('Failed to sign in: ${e.message}');
  //       return SignInResult.failed;
  //   }
  //   }
  // }

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
                      : Colors.red,
                ),
                const Gap(10),
                AuthTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  obscureText: true,
                  color: authProvider.errorMessage.isEmpty
                      ? Colors.white
                      : Colors.red,
                ),
                const Gap(10),
                AuthButton(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                      // ApalahProvider authError = ApalahProvider();
                      // setState(() {
                      //   err = authError.isError;
                      // });
                      // print('auth error ${authError.isError}');

                      await authProvider.signIn(emailTextController.text,
                          passwordTextController.text);
                      setState(() {
                        authProvider.errorMessage;
                      });
                      print('error is ${authProvider.errorMessage}');
                      if (context.mounted) Navigator.pop(context);
                    },
                    text: 'Sign In'),
                const Gap(10),
                authProvider.errorMessage.isNotEmpty
                    ? Column(
                        children: [
                          Text(
                            authProvider.errorMessage,
                            style: TextStyle(color: Colors.red[900]),
                          ),
                          const Gap(10),
                          RegisterText(widget: widget)
                        ],
                      )
                    : RegisterText(widget: widget)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterText extends StatelessWidget {
  const RegisterText({
    super.key,
    required this.widget,
  });

  final LoginPage widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Belum mempunyai akun ?',
          style: TextStyle(color: Colors.grey[700]),
        ),
        const Gap(7),
        GestureDetector(
            onTap: widget.onTap,
            child: const Text(
              'Daftar Sekarang!',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            )),
      ],
    );
  }
}
