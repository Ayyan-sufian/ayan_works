import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'login-page.dart';
import 'wrapper.dart';

class VerifyPg extends StatefulWidget {
  const VerifyPg({super.key});

  @override
  State<VerifyPg> createState() => _VerifyPgState();
}

class _VerifyPgState extends State<VerifyPg> {
  @override
  void initState() {
    sendverifylink();
    super.initState();
  }

  sendverifylink() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification().then(
      (value) => {
        Get.snackbar(
          'Link sent ',
          'A link has been sent to your email',
          margin: EdgeInsets.all(30),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black38,
          colorText: Colors.white,
        ),
      },
    );
  }

  reload() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      Get.offAll(wrapperPg());
    } else {
      Get.snackbar(
        'Not Verified',
        'Please verify your email before continuing.',
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verification page")),
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
                  Image.asset("assets/img/revo-first.png"),
                ],
              ),
            ),
            Container(
              height: 500,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(21),
                  topRight: Radius.circular(21),
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: Text(
                        "Open your mail and click on the link to verify and reload this page.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 258.0, left: 300),
                    child: FloatingActionButton(
                      onPressed: () => reload(),
                      backgroundColor: Colors.white,
                      child: Icon(Icons.refresh_outlined, color: Colors.black),
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
