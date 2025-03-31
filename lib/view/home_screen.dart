// Desactivación de advertencias específicas para mantener el código limpio
// ignore_for_file: use_key_in_widget_constructors, implementation_imports, prefer_const_constructors_in_immutables, unused_import, deprecated_member_use

// Importaciones necesarias para el funcionamiento
import 'package:flutter/material.dart';           // Widgets base de Flutter
import 'package:google_fonts/google_fonts.dart';  // Fuentes de Google
import 'package:heartwise/view/analisis_clinico.dart';      // Pantalla de análisis clínico
import 'package:heartwise/view/evaluacion_corporal.dart';    // Pantalla de evaluación corporal
import 'package:heartwise/view/perfil_genetico.dart';        // Pantalla de perfil genético
import 'package:mysql1/src/single_connection.dart';          // Conexión a base de datos

// Clase principal que representa la pantalla de inicio
// ignore: camel_case_types
class home_screen extends StatelessWidget {
  // Propiedades de la clase
  final Map<String, dynamic>? userInfo;  // Información del usuario

  // Constructor de la clase
  home_screen({super.key, this.userInfo});

  @override
  Widget build(BuildContext context) {
    // Cálculo de dimensiones responsivas para el carrusel
    double carruselHeight = (MediaQuery.of(context).size.height)* 0.5;  // 50% del alto de pantalla
    double carruselWidth = (MediaQuery.of(context).size.width) * 0.75;  // 75% del ancho de pantalla

    // Conversión de datos del usuario a Map
    Map<String, dynamic> userInfoMap = {};
    if (userInfo != null) {
      userInfo?.forEach((key, value) {
        userInfoMap[key] = value;
      });
    }

    // Obtención del rol del usuario (por defecto 'publico')
    String rol = userInfoMap['rol'] ?? 'publico';

    // Lista de pruebas disponibles con sus características
    final List<Map<String, dynamic>> datos = [
      {
        'titulo': 'Evaluación Corporal Básica',
        'descripcion': 'Evalúa tus parámetros físicos clave...',
        'disponible': true,  // Siempre disponible
        'direc': EvaluacionCorporalScreen(
          userData: userInfoMap, 
          tipoAnalisis: 'AnalisisClinicosv1',
        )
      },
      {
        'titulo': 'Análisis Clínico Integral',
        'descripcion': 'Evalúa tus parámetros físicos clave...',
        'disponible': rol == 'medico' ? true : false,  // Solo para médicos
        'direc': AnalisisClinicoScreen(
          userData: userInfoMap, 
          tipoAnalisis: 'AnalisisCrlinicosv2',
        )
      },
      {
        'titulo': 'Perfil Genético Avanzado',
        'descripcion': 'Analiza tu ADN y metabolismo...',
        'disponible': rol == 'medico' ? true : false,  // Solo para médicos
        'direc': PerfilGeneticoScreen(
          userData: userInfoMap, 
          tipoAnalisis: 'Geneticos',
        )
      },
    ];

    // Construcción de la interfaz
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
          left: 20,
          right: 20,
          bottom: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con información del usuario
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del usuario
                    Text(
                      '${userInfoMap['nombre']}',
                      style: GoogleFonts.inder(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    ),
                    // Mensaje de bienvenida
                    Text(
                      'Bienvenido de vuelta!',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                const Spacer(),
                // Logo de la aplicación
                Image.asset(
                  'lib/sources/heart-red.png',
                  width: 50, 
                  height: 50, 
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ],
            ),

            const SizedBox(height: 16),
            // Título de la sección de pruebas
            Text(
              'Pruebas de Estudio \nCardiovasculares',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            // Carrusel de pruebas disponibles
            SizedBox(
              height: carruselHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: datos.length,
                itemBuilder: (context, index){
                  final item = datos[index];
                  return Container(
                    width: carruselWidth,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: _buildCardPrueba(
                      context: context,
                      titulo: item['titulo'],
                      descripcion: item['descripcion'],
                      disponible: item['disponible'],
                      direc: item['direc']
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para construir las tarjetas de pruebas
  Widget _buildCardPrueba({
    required BuildContext context,
    required String titulo,
    required String descripcion,
    bool disponible = false,
    Widget? direc,
  }) {
    // Renderizado condicional basado en disponibilidad
    return disponible ? 
      // Tarjeta para pruebas disponibles
      GestureDetector(
        onTap: () {
          if(direc!= null){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => direc),
            );
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.white, width: 2,)
          ),
          elevation: 20,
          color: const Color(0xFFDC3644),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Etiqueta de disponibilidad
                Container(
                  width: 150,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Disponible',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFFDC3644),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Título de la prueba
                Text(
                  titulo,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Descripción de la prueba
                Card(
                  elevation: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE54653),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      descripcion, 
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Botón de acción
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Realizar',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.transparent,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      )
      : 
      // Tarjeta para pruebas no disponibles
      Card(
        elevation: 10,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Etiqueta de restricción
              Container(
                width: 150,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Solo Médicos',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Título de la prueba
              Text(
                titulo,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Descripción de la prueba
              Card(
                elevation: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    descripcion, 
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // Mensaje de restricción
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Acude al médico',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.transparent.withOpacity(0),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      );
  }
}