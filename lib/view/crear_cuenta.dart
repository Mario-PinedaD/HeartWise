// register_screen.dart
// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heartwise/view/home_screen.dart';
import 'package:heartwise/view/login_screen.dart';
import '../service/database_service.dart';

// Widget principal para la pantalla de registro
// Utiliza StatefulWidget para manejar el estado interno
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

// Estado del widget RegisterScreen
class _RegisterScreenState extends State<RegisterScreen> {
  // Variables para almacenar los datos del formulario
  DateTime? _fechaSeleccionada; // Fecha de nacimiento seleccionada
  int? edad; // Edad calculada
  String? selectedGender; // Género seleccionado
  bool _isPasswordVisible = false; // Control de visibilidad de la contraseña

  // Controladores para los campos de texto
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color de fondo rojo característico de la app
      backgroundColor: const Color(0xFFDC3644),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo de la aplicación
            Image.asset('lib/sources/heart.png',
                width: 50, height: 50, fit: BoxFit.contain),
            const SizedBox(height: 20),

            // Título de la pantalla
            Text(
              'Crear una Cuenta',
              style: GoogleFonts.inder(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Tarjeta principal que contiene el formulario
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Ingresa tu información',
                      style: GoogleFonts.inder(
                          textStyle: const TextStyle(fontSize: 16),
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // Campo de nombre
                    TextField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre Completo',
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
                            borderRadius: BorderRadius.circular(12)),
                        fillColor: Colors.white.withOpacity(0.1),
                        filled: true,
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
                            borderRadius: BorderRadius.circular(12)),
                        fillColor: Colors.white.withOpacity(0.1),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Selector de fecha y género
                    Row(
                      children: [
                        // Botón de fecha de nacimiento
                        TextButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2100));
                            if (pickedDate != null) {
                              setState(() {
                                _fechaSeleccionada = pickedDate;
                                edad = DateTime.now()
                                        .difference(_fechaSeleccionada!)
                                        .inDays ~/
                                    365;
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            foregroundColor: Colors.white,
                            side: BorderSide(
                                color: Colors.black.withOpacity(0.3)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const SizedBox(
                                height: 50,
                              ),
                              Text(
                                _fechaSeleccionada == null
                                    ? 'Fecha de Nacimiento'
                                    : '${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Selector de género
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButton<String>(
                              value: selectedGender,
                              hint: Text(
                                'Sexo',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.black),
                              underline: const SizedBox(),
                              style: GoogleFonts.inder(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              items: <String>['Hombre', 'Mujer']
                                  .map((String gender) {
                                return DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedGender = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Campo de contraseña
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
                            borderRadius: BorderRadius.circular(12)),
                        fillColor: Colors.white.withOpacity(0.1),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Campo de ciudad
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Ciudad',
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
                            borderRadius: BorderRadius.circular(12)),
                        fillColor: Colors.white.withOpacity(0.1),
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botón de registro
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  minimumSize: const Size(10, 60)),
              onPressed: () async {
                // Obtener valores de los campos
                String nombre = _nombreController.text;
                String email = _emailController.text;
                String password = _passwordController.text;
                String sexo = selectedGender.toString();

                // Validación de campos
                if (nombre.isNotEmpty &&
                    email.isNotEmpty &&
                    _fechaSeleccionada != null &&
                    selectedGender != null &&
                    password.isNotEmpty) {
                  // Convertir fecha a formato ISO
                  final String fechaIso = _fechaSeleccionada!.toIso8601String();

                  // Llamada al servicio de registro
                  final result = await DatabaseService.registrarUsuario({
                    'nombre': nombre,
                    'email': email,
                    'fechaNacimiento': fechaIso,
                    'genero': sexo,
                    'password': password,
                  });

                  // Mostrar mensaje de éxito y navegar a home
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Resultado enviado, respuesta: $result')),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => home_screen(
                              userInfo: {'nombre': nombre},
                            )),
                  );
                } else {
                  // Mostrar mensaje de error si faltan campos
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, completa todos los campos.')),
                  );
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Text(
                  'Registrarse',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),

            // Enlace a la pantalla de login
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              child: const Text('Ya tienes una cuenta? Inicia Sesión',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
