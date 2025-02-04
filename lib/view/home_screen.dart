import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class home_screen extends StatelessWidget {

  final List<Map<String, dynamic>> datos = [
    {'titulo': 'Evaluación Corporal Básica',
      'descripcion': 'Evalúa tus parámetros físicos clave, como peso, IMC y composición corporal para un control básico de tu salud.',
      'disponible': true},
    {'titulo': 'Análisis Clínico Integral',
      'descripcion': 'Evalúa tus parámetros físicos clave, como peso, IMC y composición corporal para un control básico de tu salud.',
      'disponible': false},
    {'titulo': 'Perfil Genético Avanzado',
      'descripcion': 'Analiza tu ADN y metabolismo para una evaluación profunda de salud, enfocada en la prevención de enfermedades a nivel molecular.',
      'disponible': false},
  ];
  @override
  Widget build(BuildContext context) {
    //Para el alto del carrusel
    double carruselHeight = (MediaQuery.of(context).size.height)* 0.5;
    double carruselHeightMin = carruselHeight - 30;

    //Para el ancho del carrusel
    double carruselWidth = (MediaQuery.of(context).size.width) * 0.75;
    double carruselWidthMin = carruselWidth - 30;


    return Scaffold(
      backgroundColor: Color(0xFFD9D9D9),
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
                    'Usuario hermoso precioso',
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
                Spacer(),
                Image.asset('lib/sources/heart-red.png',
                    width: 50, height: 50, fit: BoxFit.contain, alignment: Alignment.bottomCenter,),
              ],
            ),

            SizedBox(height: 16),
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
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: _buildCardPrueba(
                        titulo: item['titulo'],
                        descripcion: item['descripcion'],
                        disponible: item['disponible'],
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
    required String titulo,
    required String descripcion,
    bool disponible = false,
  }) {
    return disponible ? // Aquí se cumpliran los casos verdaderos
    Card(
      elevation: 10, //Esto es lo que le da la sombra coqueta
      color: Color(0xFFDC3644),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Disponible',
              style: GoogleFonts.poppins(
                fontSize: 16,
                backgroundColor: Colors.white,
                color: Color(0xFFDC3644),
              ),
            ),
            SizedBox(height: 10),
            Text(
              titulo,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(descripcion, style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
              backgroundColor: Color(0xFFE54653),
            ),),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // Acción al presionar "Realizar"
                },
                child: Text('Realizar',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.transparent,
                      color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
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
            Text(
              'Solo Médicos',
              style: GoogleFonts.poppins(
                fontSize: 16,
                backgroundColor: Colors.black,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              titulo,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(descripcion, style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
              backgroundColor: Colors.grey.withOpacity(.5),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // Acción al presionar "Realizar"
                },
                child: Text('Realizar',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.red.withOpacity(0),
                      color: Colors.grey.withOpacity(.5),

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}