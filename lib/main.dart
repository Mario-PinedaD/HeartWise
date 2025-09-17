// ignore_for_file: unused_import, duplicate_import

import 'package:flutter/material.dart'; // Importa la librería de Flutter para la interfaz de usuario
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa el paquete para cargar variables de entorno desde un archivo .env
import 'package:heartwise/view/splash_screen.dart'; // Importa la pantalla de splash con verificación de sesión

void main() async {
  // Función principal asíncrona que se ejecuta al iniciar la aplicación
  try {
    await dotenv.load(
        fileName:
            ".env"); // Carga las variables de entorno desde el archivo .env
    runApp(const HeartWiseApp()); // Inicia la aplicación HeartWise
  } catch (e) {
    print(
        "Error cargando .env: $e"); // Imprime un mensaje de error si no se puede cargar el archivo .env
    // Continuar con la app incluso si no se carga el .env
    runApp(
        const HeartWiseApp()); // Inicia la aplicación HeartWise incluso si hay un error al cargar el .env
  }
}

class HeartWiseApp extends StatelessWidget {
  // Widget principal de la aplicación
  const HeartWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Método que construye la interfaz de usuario
    return MaterialApp(
        // Widget que define la estructura básica de la aplicación
        debugShowCheckedModeBanner:
            false, // Desactiva la etiqueta de "debug" en la esquina superior derecha
        title: 'HeartWise', // Define el título de la aplicación
        home:
            const SplashScreen() // Establece el splash screen como pantalla inicial
        );
  }
}
