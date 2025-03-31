// login_screen.dart
// ignore_for_file: deprecated_member_use, use_build_context_synchronously, library_private_types_in_public_api

// Importaciones necesarias para el funcionamiento de la pantalla de login
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heartwise/view/crear_cuenta.dart';
import 'package:heartwise/view/home_screen.dart';
import 'package:heartwise/service/database_service.dart';

/// Widget principal para la pantalla de inicio de sesión
/// Maneja el estado de los campos del formulario y la autenticación
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreen createState() => _LoginScreen();
}

/// Estado del widget LoginScreen que contiene la lógica de la interfaz
class _LoginScreen extends State<LoginScreen> {
  // Control de visibilidad del campo de contraseña
  bool _isPasswordVisible = false;

  // Controladores para los campos de texto
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Cálculo del ancho del botón basado en el ancho de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.6; // 60% del ancho de la pantalla

    return Scaffold(
      // Color de fondo principal de la aplicación
      backgroundColor: const Color(0xFFDC3644),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo de la aplicación
            Image.asset(
              'lib/sources/heart.png',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            // Título de la pantalla
            Text(
              'Iniciar Sesión',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Tarjeta que contiene el formulario de login
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtítulo del formulario
                    Text(
                      'Ingresa tus credenciales',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Campo de correo electrónico
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        labelStyle: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.white.withOpacity(0.1),
                        filled: true,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Campo de contraseña con toggle de visibilidad
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        hintText: 'Genera tu contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.white.withOpacity(0.1),
                        filled: true,
                      ),
                    ),

                    // Enlace para recuperar contraseña
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implementar recuperación de contraseña
                        },
                        child: Text(
                          'Perdiste tu contraseña?',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botón principal de inicio de sesión
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                minimumSize: Size(buttonWidth, 60),
              ),
              onPressed: () async {
                // Obtiene los valores de los campos
                String email = _emailController.text;
                String password = _passwordController.text;

                // Validación de campos completos
                if (email.isNotEmpty && password.isNotEmpty) {
                  // Intento de autenticación
                  final result = await DatabaseService.enviarUsuario(
                    {'email': email, 'password': password},
                  );

                  // Procesamiento de la respuesta
                  if (result != null && result['usuario'] != null) {
                    Map<String, dynamic> userInfo = result['usuario'];

                    // Muestra mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Inicio de sesión exitoso')),
                    );

                    // Navega a la pantalla principal
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => home_screen(userInfo: userInfo),
                      ),
                    );
                  } else {
                    // Muestra error de credenciales inválidas
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Usuario o contraseña incorrectos.'),
                      ),
                    );
                  }
                } else {
                  // Muestra error de campos incompletos
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, completa todos los campos.'),
                    ),
                  );
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Text(
                  'Entrar',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Enlace para crear nueva cuenta
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: Text(
                'No tienes una cuenta? Crear una',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
