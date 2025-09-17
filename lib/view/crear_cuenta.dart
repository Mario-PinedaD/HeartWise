// register_screen.dart
// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heartwise/view/home_screen.dart';
import '../service/database_service.dart';

// Widget principal para la pantalla de registro moderno
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
  final TextEditingController _ciudadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo rojo sólido como en evaluación corporal
      backgroundColor: const Color(0xFFDC3644),
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Título mejorado de la pantalla
                  Column(
                    children: [
                      Text(
                        'Únete a HeartWise',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Crea tu cuenta personalizada y comienza tu viaje hacia una mejor salud cardiovascular.\nNuestros expertos te acompañarán en cada paso.',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Tarjeta moderna que contiene el formulario
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          // Subtítulo del formulario mejorado
                          Text(
                            'Datos Personales y de Contacto',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFDC3644),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Campo de nombre moderno
                          TextField(
                            controller: _nombreController,
                            decoration: InputDecoration(
                              labelText: 'Nombre Completo',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Colors.grey[400],
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xFFDC3644), width: 2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              fillColor: Colors.grey[50],
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Campo de correo electrónico moderno
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Correo Electrónico',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.grey[400],
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xFFDC3644), width: 2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              fillColor: Colors.grey[50],
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Fila de fecha de nacimiento y género modernos
                          Row(
                            children: [
                              // Botón de fecha de nacimiento moderno
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime(2100),
                                    );
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
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(16),
                                      border:
                                          Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 20),
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _fechaSeleccionada == null
                                                ? 'Fecha de Nacimiento'
                                                : '${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: _fechaSeleccionada == null
                                                  ? Colors.grey[600]
                                                  : Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Selector de género moderno
                              Expanded(
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      Icon(
                                        Icons.wc_outlined,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: DropdownButton<String>(
                                          value: selectedGender,
                                          hint: Text(
                                            'Género',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          dropdownColor: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          icon: Icon(Icons.arrow_drop_down,
                                              color: Colors.grey[400]),
                                          underline: const SizedBox(),
                                          isExpanded: true,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          items: <String>[
                                            'Masculino',
                                            'Femenino'
                                          ].map((String gender) {
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
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Campo de contraseña moderno
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                              hintText: 'Crea una contraseña segura',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.grey[400],
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.grey[400],
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey[400],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xFFDC3644), width: 2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              fillColor: Colors.grey[50],
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Campo de ciudad moderno
                          TextField(
                            controller: _ciudadController,
                            decoration: InputDecoration(
                              labelText: 'Ciudad',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                              prefixIcon: Icon(
                                Icons.location_city_outlined,
                                color: Colors.grey[400],
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xFFDC3644), width: 2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              fillColor: Colors.grey[50],
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Botón de registro moderno
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFDC3644),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        // Obtener valores de los campos
                        String nombre = _nombreController.text;
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        String ciudad = _ciudadController.text;
                        String sexo = selectedGender.toString();

                        // Validación de campos
                        if (nombre.isNotEmpty &&
                            email.isNotEmpty &&
                            _fechaSeleccionada != null &&
                            selectedGender != null &&
                            password.isNotEmpty &&
                            ciudad.isNotEmpty) {
                          // Convertir fecha a formato ISO
                          final String fechaIso =
                              _fechaSeleccionada!.toIso8601String();

                          // Llamada al servicio de registro
                          final result =
                              await DatabaseService.registrarUsuario({
                            'nombre': nombre,
                            'email': email,
                            'fechaNacimiento': fechaIso,
                            'genero': sexo,
                            'password': password,
                            'ciudad': ciudad,
                          });

                          // Mostrar mensaje de éxito y navegar a home
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cuenta creada exitosamente'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => home_screen(
                                userInfo: {'nombre': nombre},
                              ),
                            ),
                          );
                        } else {
                          // Mostrar mensaje de error si faltan campos
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Por favor, completa todos los campos.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Crear Cuenta',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFDC3644),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Enlace moderno a la pantalla de login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Ya eres miembro de HeartWise? ',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Regresar a la pantalla anterior (login)
                        },
                        child: Text(
                          'Iniciar Sesión',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
