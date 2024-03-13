import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/reddit.dart';
import '../models/users.dart';

/*could place this into a class */
final db = FirebaseFirestore.instance;
final fba = FirebaseAuth.instance;
//current user
final String uid = fba.currentUser!.uid;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  //variables
  late Future<Map<int, RedditModel>> RedditStream;
  //storing dict for jsonEncode
  Map<String, String> user_objs = {
    'uid': uid,
    'reward': "None",
    'mileage': "None",
    'attendance': "None"
  };

  //grab data of current user
  final Stream<DocumentSnapshot<Map<String, dynamic>>> _userStream =
      db.collection('users').doc(uid).snapshots();

  //grab reddit stream
  Future<Map<int, RedditModel>> _getStreamReddit() async {
    try {
      final resp = await http.get(Uri.parse('http://localhost:8000/'));
      if (resp.statusCode == 200) {
        {
          //map to store decoded json
          Map<int, RedditModel> decoded_json = {};
          //parse the JSON.
          for (int i = 0; i < resp.body.length; i++) {
            decoded_json[i] = RedditModel.fromJson(
                jsonDecode(resp.body[i]) as Map<String, dynamic>);
          }
          return decoded_json;
        }
      } else {
        throw Exception("couldn't get data");
      }
    } catch (e) {
      throw (e);
    }
  }

  //update data of current user
  Future<RewardModel> postEntry() async {
    try {
      final response =
          await http.put(Uri.parse('http://127.0.0.1:5000/rewards'),
              headers: <String, String>{
                'Content-type': 'application/json',
              },
              body: jsonEncode(user_objs));
      if (response.statusCode == 200) {
        return RewardModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      throw (e);
    }
  }

  //subtraction on button press
  void Reduce(String item, double value) {
    if (value > 0) {
      value -= 1;
      user_objs[item] = value.toString();
      postEntry();
      user_objs[item] = "None";
    }
  }

  //addition on button press
  void Gain(String item, double value) {
    if (value >= 0) {
      value += 1;
      user_objs[item] = value.toString();
      postEntry();
      user_objs[item] = "None";
    }
  }

  //sign out function
  void signOut() {
    fba.signOut();
  }

  //add in reddit stream in initialzing app
  @override
  void initState() {
    super.initState();
    RedditStream = _getStreamReddit();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _userStream,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
              appBar: AppBar(actions: [
                IconButton(onPressed: signOut, icon: Icon(Icons.logout)),
              ]),
              body: SafeArea(
                  child: ListView(
                children: [
                  Row(
                    children: [Text("username:"), Text(data['username'])],
                  ),
                  Row(
                    children: [
                      Text("reward: "),
                      Text(data['reward'].toString()),
                      //increase reward
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(30, 20),
                        ),
                        child: const Icon(Icons.remove, color: Colors.purple),
                        onPressed: () => Reduce('reward', data['reward']),
                      ),
                      //decrease reward
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(30, 20),
                        ),
                        child: const Icon(Icons.add, color: Colors.purple),
                        onPressed: () => Gain('reward', data['reward']),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("mileage:"),
                      Text(data['mileage'].toString()),
                      //increase mileage
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(30, 20),
                        ),
                        child: const Icon(Icons.remove, color: Colors.purple),
                        onPressed: () => Reduce('mileage', data['mileage']),
                      ),
                      //decrease mileage
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(30, 20),
                        ),
                        child: const Icon(Icons.add, color: Colors.purple),
                        onPressed: () => Gain('mileage', data['mileage']),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("attendance:"),
                      Text(data['attendance'].toString()),
                      //increase attendance
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(30, 20),
                        ),
                        child: const Icon(Icons.remove, color: Colors.purple),
                        onPressed: () =>
                            Reduce('attendance', data['attendance']),
                      ),
                      //decrease attendance
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(30, 20),
                        ),
                        child: const Icon(Icons.add, color: Colors.purple),
                        onPressed: () => Gain('attendance', data['attendance']),
                      ),
                    ],
                  ),
                ],
              )));
        });
  }
}
