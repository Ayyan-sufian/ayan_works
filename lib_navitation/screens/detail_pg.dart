import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailPg extends StatefulWidget {
  const DetailPg({super.key});

  @override
  State<DetailPg> createState() => _DetailPgState();
}

class _DetailPgState extends State<DetailPg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Navigation App")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Welcome to Detail page",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text("")),
        ],
      ),
    );
  }
}
