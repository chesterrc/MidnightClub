import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midnightclub_main/pages/signuppage.dart';

import '../components/LoginTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //variables/controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final signUpPushed = false;

  //wrong sign in alert
  void authAlert(String message) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Color.fromARGB(255, 73, 10, 121),
          title: Center(
            child: Text(
              "Wrong email or password",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  //SignIn function
  void signIn() async {
    //circular loading
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    //user authentication
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //alertperson
      authAlert(e.code);
    }
  }

  //toggle to sign up page
  void toggleSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => SignUpPage()),
    );
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
                hintText: "Username",
                obscureText: false,
              ),

              const SizedBox(height: 50), //space

              //password
              LoginTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),

              const SizedBox(height: 50), //space

              //forgot password idk if this is const
              const Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20), //space

              //sign in button
              Container(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 73, 10, 121)),
                  ),
                  onPressed: () => signIn(),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10), //space

              //continue with
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "or continue with",
                        style: TextStyle(
                          color: Color.fromARGB(255, 141, 140, 140),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30), //space

              //Sign Up button
              Container(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => toggleSignUp(),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color.fromARGB(255, 57, 7, 95),
                    ),
                  ),
                ),
              )

              //google sign in buttons
            ]),
          ),
        ),
      ),
    );
  }
}
