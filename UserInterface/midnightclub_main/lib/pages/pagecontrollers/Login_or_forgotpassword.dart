import 'package:flutter/material.dart';
import 'package:midnightclub_main/pages/ForgotPasswordPage.dart';

import '../loginpage.dart';

class LoginOrForgot extends StatefulWidget {
  const LoginOrForgot({super.key});

  @override
  State<LoginOrForgot> createState() => _LoginorForgotState();
}

class _LoginorForgotState extends State<LoginOrForgot> {
  //variables
  bool showLoginpage = true;

  void togglePages() {
    setState(() {
      showLoginpage = !showLoginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginpage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return ForgotPassPage(
        onTap: togglePages,
      );
    }
  }
}
