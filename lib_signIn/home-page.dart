import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'user-data.dart';

class HomePage extends StatefulWidget {
  final String userName;
  const HomePage({super.key, required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.userName.isNotEmpty ? widget.userName : "Guest";
    return Scaffold(
      appBar: AppBar(title: Text("Firebase app")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 340),
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserData(userName: userName),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.person_2_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 509,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(21),
                  topLeft: Radius.circular(21),
                ),
                color: Colors.black,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -220,
                    right: -60,
                    child: Image.asset(
                      "assets/img/oshan-first.png",
                      height: 200,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 38.0),
                    child: Center(
                      child: Text(
                        "${widget.userName} Welcome to home Page",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      signOut();
                    },
                    icon: Icon(Icons.exit_to_app),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
