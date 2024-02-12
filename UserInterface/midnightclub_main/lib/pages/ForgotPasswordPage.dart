import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/LoginTextField.dart';

class ForgotPassPage extends StatefulWidget {
  final void Function()? onTap;
  const ForgotPassPage({super.key, required this.onTap});

  @override
  State<ForgotPassPage> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPassPage> {
  //variables/controllers
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  //alert about exceptions
  void passwordAuthException() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Color.fromARGB(255, 73, 10, 121),
          title: Center(
            child: Text(
              "No user of that email",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  //alert about a sent email to reset password
  void passwordResetSent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Color.fromARGB(255, 73, 10, 121),
          title: Center(
            child: Text(
              "An email to reset your password has been sent",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  //reset password
  void resetPass() async {
    //circular loading
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    //send password reset email
    try {
      await auth.sendPasswordResetEmail(email: emailController.text);
      Navigator.pop(context);
      passwordResetSent();
    } catch (e) {
      passwordAuthException();
    }
  }

  //building the page
  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 18, 18),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 50), //space

              //logo
              const Text(
                "Midnight Club",
                style: TextStyle(
                  color: Color.fromARGB(255, 73, 10, 121),
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),

              const SizedBox(height: 50), //space

              //email
              LoginTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),

              const SizedBox(height: 50), //space

              //return back to login page
              Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Remember your password? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text("Login!",
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20), //space

              //Reset password button
              Container(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 73, 10, 121)),
                  ),
                  onPressed: () => resetPass(),
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10), //space
            ]),
          ),
        ),
      ),
    );
  }
}
