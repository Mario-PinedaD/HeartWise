// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:heartwise/view/crear_cuenta.dart';
import 'package:heartwise/view/evaluacion_corporal.dart';
//import 'package:heartwise/view/evaluacion_corporal.dart';
import 'package:heartwise/view/home_screen.dart';
//import 'package:heartwise/view/home_screen.dart'
import 'package:heartwise/view/perfil_genetico.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:heartwise/view/resultados_screen.dart';
import 'package:heartwise/view/perfil_genetico.dart';

void main() async{
  try {
    await dotenv.load(fileName: ".env");
    runApp(const HeartWiseApp());
  } catch (e) {
    print("Error cargando .env: $e");
    // Continuar con la app incluso si no se carga el .env
    runApp(const HeartWiseApp());
  }
}

class HeartWiseApp extends StatelessWidget {
  const HeartWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HeartWise',
      //home: WelcomeScreen(),
      //home: home_screen(),
      //home: EvaluacionCorporalScreen(),
      //home: AnalisisClinicoScreen(),
      //home: RegisterScreen(),
      home: ResultadosScreen(),
    );
  }
}

