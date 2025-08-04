import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'img-picker.dart';
import 'wrapper.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Uint8List? _image;

  bool _obscure = true;
  bool isloading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  List<IconData> _icons = [Icons.visibility, Icons.visibility_off];
  signup() async {
    if (_image == null ||
        name.text.isEmpty ||
        email.text.isEmpty ||
        password.text.isEmpty) {
      Get.snackbar("Error", "All fields are required including profile image");
      return;
    }

    setState(() {
      isloading = true;
    });

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          );

      final userId = userCredential.user?.uid;
      if (userId == null) throw Exception("User creation failed");

      Get.offAll(wrapperPg());
    } catch (e) {
      print('Signup failed: $e');
      Get.snackbar("Signup Failed", e.toString());
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  void optionForCam() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt_outlined),
              title: Text("camera"),
              onTap: () async {
                Navigator.pop(context);
                final img = await pickImage(ImageSource.camera);
                if (img != null) {
                  setState(() {
                    _image = img;
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text("Gallery"),
              onTap: () async {
                Navigator.pop(context);
                final img = await pickImage(ImageSource.gallery);
                if (img != null) {
                  setState(() {
                    _image = img;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign-up page")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 338.0),
                  child: _image != null
                      ? CircleAvatar(
                          radius: 30,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            "https://cdn.imgbin.com/11/6/21/imgbin-computer-icons-login-person-user-avatar-log-KafDHUcGyAGRw1fv3nyHP6qhy.jpg",
                          ),
                        ),
                ),
                Positioned(
                  bottom: -16,
                  right: -15,
                  child: IconButton(
                    onPressed: () {
                      optionForCam();
                    },
                    icon: Icon(Icons.add_a_photo, size: 16),
                  ),
                ),
              ],
            ),
            Container(
              height: 280,
              child: Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset("assets/img/haval-four.png"),
              ),
            ),
            Container(
              height: 509,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(21),
                  topRight: Radius.circular(21),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      "Plz! Enter you email to continue.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
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
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(21),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber, width: 3),
                          borderRadius: BorderRadius.circular(21),
                        ),
                        label: Text(
                          "Email",
                          style: TextStyle(color: Colors.white),
                        ),
                        hintText: "Enter your email.",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: password,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        label: Text(
                          "Password",
                          style: TextStyle(color: Colors.white),
                        ),
                        hintText: "Enter your email.",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(21),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber, width: 3),
                          borderRadius: BorderRadius.circular(21),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscure = !_obscure;
                            });
                          },
                          icon: Icon(_obscure ? _icons[0] : _icons[1]),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),

                    child: isloading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => signup(),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: Size(420, 50),
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
