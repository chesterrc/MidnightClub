import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/LoginTextField.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //controllers/vars
  final emailController = TextEditingController();
  final profileNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordcontroller = TextEditingController();

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

  //signup handler
  void signUp() async {
    //circular loading
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    //sign up authentication
    try {
      if (passwordController.text == confirmPasswordcontroller.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        Navigator.pop(context);
        //alert about wrong confirmation password
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              backgroundColor: Color.fromARGB(255, 73, 10, 121),
              title: Center(
                child: Text(
                  "Passwords do not match",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      }
      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 73, 10, 121),
        centerTitle: true,
        title: const Text(
          "Midnight Club",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ListView(children: [
            const SizedBox(height: 50), //space

            //email
            LoginTextField(
              controller: emailController,
              hintText: "Email",
              obscureText: false,
            ),

            const SizedBox(height: 50), //space

            //Username
            LoginTextField(
              controller: profileNameController,
              hintText: "Username",
              obscureText: false,
            ),

            const SizedBox(height: 50), //space

            //password
            LoginTextField(
              controller: passwordController,
              hintText: "Confirm Password",
              obscureText: true,
            ),

            const SizedBox(height: 50), //space

            //confirm password
            LoginTextField(
              controller: confirmPasswordcontroller,
              hintText: "Password",
              obscureText: true,
            ),

            const SizedBox(height: 50), //space

            //sign Up button
            Container(
              width: 100,
              height: 50,
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 73, 10, 121)),
                ),
                onPressed: () => signUp(),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),

            //space
            const SizedBox(height: 50)
          ]),
        ),
      ),
    );
  }
}
