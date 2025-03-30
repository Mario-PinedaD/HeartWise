// ignore_for_file: use_key_in_widget_constructors, implementation_imports, prefer_const_constructors_in_immutables, unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heartwise/view/analisis_clinico.dart';
import 'package:heartwise/view/evaluacion_corporal.dart';
import 'package:heartwise/view/perfil_genetico.dart';
import 'package:mysql1/src/single_connection.dart';

// ignore: camel_case_types
class home_screen extends StatelessWidget {

  //final Results? userInfo;
  final Map<String, dynamic>? userInfo;
  home_screen({super.key, this.userInfo});


  // home_screen({super.key, this.userInfo}) {
  //   print(userInfo);
  // }

  @override
  Widget build(BuildContext context) {
    //Para el alto del carrusel
    double carruselHeight = (MediaQuery.of(context).size.height)* 0.5;
    //double carruselHeightMin = carruselHeight - 30;

    //Para el ancho del carrusel
    double carruselWidth = (MediaQuery.of(context).size.width) * 0.75;
    //double carruselWidthMin = carruselWidth - 30;

    Map<String, dynamic> userInfoMap = {};
    if (userInfo != null) {
      userInfo?.forEach((key, value) {
        userInfoMap[key] = value;
      });
    }

    String rol = userInfoMap['rol'] ?? 'publico';

    final List<Map<String, dynamic>> datos = [
    {'titulo': 'Evaluación Corporal Básica',
      'descripcion': 'Evalúa tus parámetros físicos clave, como peso, IMC y composición corporal para un control básico de tu salud.',
      'disponible': true,
      'direc': EvaluacionCorporalScreen(userData: userInfoMap, tipoAnalisis: 'AnalisisClinicosv1',)},
    {'titulo': 'Análisis Clínico Integral',
      'descripcion': 'Evalúa tus parámetros físicos clave, como peso, IMC y composición corporal para un control básico de tu salud.',
      'disponible': rol == 'medico' ? true : false,
      'direc': AnalisisClinicoScreen(userData: userInfoMap, tipoAnalisis: 'AnalisisCrlinicosv2',)},
    {'titulo': 'Perfil Genético Avanzado',
      'descripcion': 'Analiza tu ADN y metabolismo para una evaluación profunda de salud, enfocada en la prevención de enfermedades a nivel molecular.',
      'disponible': rol == 'medico' ? true : false,
      'direc': PerfilGeneticoScreen(userData: userInfoMap, tipoAnalisis: 'Geneticos',)},
  ];

    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0,
            left: 20,
            right: 20,
          bottom: 40,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(
                    '${userInfoMap['nombre']}',
                    style: GoogleFonts.inder(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                    Text(
                      'Bienvenido de vuelta!',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    )],
                ),
                const Spacer(),
                Image.asset('lib/sources/heart-red.png',
                    width: 50, height: 50, fit: BoxFit.contain, alignment: Alignment.bottomCenter,),
              ],
            ),

            const SizedBox(height: 16),
            Text(
              'Pruebas de Estudio \nCardiovasculares',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
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
                        direc:item['direc']
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

  Widget _buildCardPrueba({
    required BuildContext context,
    required String titulo,
    required String descripcion,
    bool disponible = false,
    //String? direc,
    Widget? direc,
  }) {
    return disponible ? // Aquí se cumpliran los casos verdaderos
    GestureDetector(
      onTap: () {
        // Aquí pasas el parámetro para redirigir al archivo deseado
        if(direc!= null){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => direc, // Aquí el archivo .dart al que deseas navegar
            ),
          );
        }
      },child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: Colors.white,
          width: 2,
        )
      ),
      elevation: 20, //Esto es lo que le da la sombra coqueta
      color: const Color(0xFFDC3644),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(
              titulo,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                color: const Color(0xFFE54653),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(descripcion, style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                //backgroundColor: Colors.grey.withOpacity(.5),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
                child: Text('Realizar',
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
    // AQUI LOS CASOS FALSOS
        : Card(
      elevation: 10, //Esto es lo que le da la sombra coqueta
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(
              titulo,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
                elevation: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(descripcion, style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Text('Acude al médico',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      // ignore: deprecated_member_use
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