import 'package:flutter/material.dart';
import 'package:visito/page/history.dart';
import 'package:visito/page/home.dart';
import 'package:visito/page/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),
    );
  }
}
