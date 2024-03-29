import 'package:flutter/material.dart';
import 'package:flutter_app_1/views/home.dart';
import 'package:flutter_app_1/views/splash.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WallArt Gallery',
      theme: ThemeData(

        primaryColor: Colors.white,
      ),
      home: Splash(),
    );
  }
}


