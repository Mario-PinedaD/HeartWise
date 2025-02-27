import 'package:flutter/material.dart';
import 'package:heartwise/view/evaluacion_corporal.dart';
import 'package:heartwise/view/home_screen.dart';
import 'package:heartwise/view/welcome_screen.dart';
//import 'package:heartwise/view/home_screen.dart'

void main() {
  runApp(HeartWiseApp());
}

class HeartWiseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HeartWise',
      //home: WelcomeScreen(),
      //home: home_screen(),
      home: EvaluacionCorporalScreen(),
    );
  }
}

