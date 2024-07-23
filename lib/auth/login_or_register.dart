import 'package:flutter/cupertino.dart';
import 'package:front_sosmed/pages/login_page.dart';
import 'package:front_sosmed/pages/register_page.dart';
import 'package:front_sosmed/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  // void togglePages(String authProvider) {
  //   setState(() {
  //     showLoginPage = !showLoginPage;
  //     authProvider = '';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    ApalahProvider authProvider =
        Provider.of<ApalahProvider>(context, listen: false);
    if (showLoginPage) {
      return LoginPage(onTap: () {
        setState(() {
          showLoginPage = !showLoginPage;
          authProvider.setErrorMessage = '';
        });
        //togglePages(authProvider.errorMessage.toString());
      });
    } else {
      return RegisterPage(onTap: () {
        setState(() {
          showLoginPage = !showLoginPage;
          authProvider.setErrorMessage = '';
        });
        // togglePages(authProvider.errorMessage.toString());
      });
    }
  }
}
