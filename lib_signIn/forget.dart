import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login-page.dart';

class ForgetPg extends StatefulWidget {
  const ForgetPg({super.key});

  @override
  State<ForgetPg> createState() => _ForgetPgState();
}

class _ForgetPgState extends State<ForgetPg> {
  bool isloading = false;
  TextEditingController email = TextEditingController();
  reset() async {
    setState(() {
      isloading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
    } catch (e) {
      print('code failed to send');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forget Page")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => loginPage(),
                              ),
                            );
                          },
                          child: Icon(Icons.arrow_back_ios_new),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: GestureDetector(
                            child: Icon(
                              Icons.person_2_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              child: Image.asset("assets/img/bmw-m5-sec.webp", height: 280),
            ),
            Container(
              height: 509,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(21),
                  topLeft: Radius.circular(21),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 98.0,
                      left: 16,
                      right: 16,
                      bottom: 10,
                    ),
                    child: Text(
                      "Enter your email to send verification code.",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        label: Text(
                          "Email",
                          style: TextStyle(color: Colors.white),
                        ),
                        hintText: "Enter your email!",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                          borderSide: BorderSide(color: Colors.amber, width: 2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ElevatedButton(
                      onPressed: () {
                        reset();
                      },
                      child: Text(
                        "Send code",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(450, 50),
                      ),
                    ),
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
