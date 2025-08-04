import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'screen/welcome_pg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  await Hive.openBox('image');

  runApp(const MyAppHive());
}

class MyAppHive extends StatelessWidget {
  const MyAppHive({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "local storage",
      debugShowCheckedModeBanner: false,
      home: WelcomePg(),
    );
  }
}
