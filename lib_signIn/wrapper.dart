import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home-page.dart';
import 'login-page.dart';
import 'verify.dart';

class wrapperPg extends StatefulWidget {
  const wrapperPg({super.key});

  @override
  State<wrapperPg> createState() => _wrapperPgState();
}

class _wrapperPgState extends State<wrapperPg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (Context, Snapshot) {
          if (Snapshot.hasData) {
            print(Snapshot.hasData);
            if (Snapshot.data!.emailVerified) {
              return HomePage(userName: '');
            } else {
              return VerifyPg();
            }
          } else {
            return loginPage();
          }
        },
      ),
    );
  }
}
