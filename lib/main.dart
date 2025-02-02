import 'package:flutter/material.dart';
import 'package:heartwise/view/welcome_screen.dart';

void main() {
  runApp(HeartWiseApp());
}

class HeartWiseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HeartWise',
      home: WelcomeScreen(),
    );
  }
}

