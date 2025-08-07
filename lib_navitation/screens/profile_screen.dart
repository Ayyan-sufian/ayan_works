import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'search_screen.dart';
import 'setting_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Navigation App")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Welcome to Profile screen",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
