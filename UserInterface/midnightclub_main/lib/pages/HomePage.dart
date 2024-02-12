import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  //sign out function
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: signOut, icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Text("Successful Login"),
      ),
    );
  }
}
