import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'forget.dart';
import 'home-page.dart';
import 'sign-up.dart';
import 'wrapper.dart';

class loginPage extends StatefulWidget {
  loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  bool isloading = false;
  bool _obscure = true;
  TextEditingController emController = TextEditingController();
  TextEditingController psController = TextEditingController();
  TextEditingController name = TextEditingController();

  List<IconData> _icons = [Icons.visibility, Icons.visibility_off];
  signIn() async {
    setState(() {
      isloading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emController.text,
        password: psController.text,
      );
    } catch (e) {
      print('login fail$e');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  reload() async {
    await FirebaseAuth.instance.currentUser!.reload().then((value) {
      Get.offAll(wrapperPg());
      Get.offAll(HomePage(userName: name.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/img/civic-first.png", height: 280),
            Text.rich(
              TextSpan(
                text: "Welcome to Login",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.amber,
                ),
                children: [
                  TextSpan(
                    text: " Page",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(21),
                  topRight: Radius.circular(21),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: name,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber, width: 3),
                          borderRadius: BorderRadius.circular(21),
                        ),
                        label: Text(
                          "Name",
                          style: TextStyle(color: Colors.white),
                        ),
                        hintText: "Enter your Name",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: emController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        label: Text(
                          "Email",
                          style: TextStyle(color: Colors.white),
                        ),
                        hintText: "Enter your password",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(21),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber, width: 3),
                          borderRadius: BorderRadius.circular(21),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: psController,
                      obscureText: _obscure,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        label: Text(
                          "Password",
                          style: TextStyle(color: Colors.white),
                        ),
                        hintText: "Enter your email!",
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscure = !_obscure;
                            });
                          },
                          icon: Icon(_obscure ? _icons[0] : _icons[1]),
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(21),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber, width: 3),
                          borderRadius: BorderRadius.circular(21),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(ForgetPg()),
                    child: Text(
                      "Forget password",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: isloading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              await signIn();
                              reload();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: Size(420, 50),
                            ),
                            child: Text(
                              "Login!",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ElevatedButton(
                      onPressed: () => Get.to(SignUp()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(420, 50),
                      ),
                      child: Text(
                        "Sign Up!",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
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
