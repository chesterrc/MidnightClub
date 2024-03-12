import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:midnightclub_main/pages/authpage.dart';

import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Midnight Club Test",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: AuthPage(),
    );
  }
}
