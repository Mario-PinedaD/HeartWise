// ignore_for_file: library_private_types_in_public_api, unrelated_type_equality_checks, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultadosScreen extends StatefulWidget {
  final String? dato1;
  final String? dato2;
  final String? dato3;
  final String? correo;
  final Map<String, dynamic>? datosIngresados;
  const ResultadosScreen({super.key, this.dato1, this.dato2, this.dato3, this.correo, this.datosIngresados});

  @override
  _ResultadosScreenState createState() => _ResultadosScreenState();
}

class _ResultadosScreenState  extends State<ResultadosScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    String description = '';

    print("Tipo de prueba: ${widget.dato3}");

    if ("${widget.dato2}" == 'bajo') {
      description = "Tu nivel de homocisteína se encuentra dentro del rango bajo. Esto sugiere un bajo riesgo de problemas de salud relacionados con la homocisteína. Sin embargo, es importante mantener un estilo de vida saludable y realizar chequeos regulares.";
    } else if ("${widget.dato2}" == 'medio') {
      description = "Tu nivel de homocisteína está normal. Sin embargo, esto podría indicar un riesgo moderado de problemas de salud relacionados con la homocisteína. Se recomienda hablar con tu médico para discutir posibles causas y medidas preventivas.";
    } else if ("${widget.dato2}" == 'alto') {
      description = "Tu nivel de homocisteína es alto. Esto indica un riesgo significativo de problemas de salud relacionados con la homocisteína. Te recomendamos encarecidamente que consultes a tu médico para realizar pruebas adicionales y determinar el tratamiento adecuado.";
    } else {
      description = "Nivel de homocisteína desconocido."; // Manejar casos inesperados
    }

    final List<Widget> ResultadosAnalisisClinicosv1 =[
      _buildResultCard("COL", "00"),
      _buildResultCard("TRG", "00"),
      _buildResultCard("HDL", "00"),
      _buildResultCard("LDL", "00"),
      _buildResultCard("VLDL", "00"),
    ];

    final List<Widget> ResultadosGeneticos = [
      _buildResultCard("ALU", "00"),
      _buildResultCard("LINE", "00"),
      _buildResultCard("SAT", "00"),
    ];

    List<Widget> resultadosToShow = [];
    List<Widget> resultadosToShow2 = [];
    List<Widget> resultadosToShow3 = [];

    if (widget.dato3 == 'AnalisisCrlinicosv2') {
      resultadosToShow = ResultadosAnalisisClinicosv1;
    } else if (widget.dato3 == 'Geneticos') {
      resultadosToShow = ResultadosGeneticos;
      resultadosToShow2 = ResultadosAnalisisClinicosv1;
    }

    return Scaffold(
      backgroundColor: Colors.red.shade700,
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "RESULTADOS",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ScaleTransition(scale: _animation,
                    child: Image.asset('lib/sources/heart-black.png',
                      width: 50, height: 50, fit: BoxFit.contain, alignment: Alignment.bottomCenter,),)
                    ,
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Niveles de Homocisteína",
                          style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.bold)
                        ),
                        Text(
                          "${widget.dato1} µmol/L",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Paciente",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  "${widget.correo}",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Detalles de Resultados",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildResultCard("Edad", "${widget.datosIngresados?['Edad']}"),
                _buildResultCard("Peso", "${widget.datosIngresados?['Peso']}"),
                _buildResultCard("Altura", "${widget.datosIngresados?['Talla']}"),
                _buildResultCard("IMC", "${widget.datosIngresados?['IMC']}"),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildResultCard("Grasa Total", "${widget.datosIngresados?['GrasaT']}"),
                _buildResultCard("Masa Muscular", "${widget.datosIngresados?['Musculo']}"),
                _buildResultCard("Metabolismo Basal", "${widget.datosIngresados?['MetabBasal']}"),
                _buildResultCard("Grasa Visceral", "${widget.datosIngresados?['GrasaVisc']}"),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var widget in resultadosToShow) widget,
              ],
            ),
            if (resultadosToShow2.isNotEmpty) // Mostrar v1 en otra fila si es necesario
              Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var widget in resultadosToShow2) widget,
                    ],
                  ),
                ],
              ),
            if (resultadosToShow3.isNotEmpty) // Mostrar v1 en otra fila si es necesario
              Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var widget in resultadosToShow3) widget,
                    ],
                  ),
                ],
              ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     for(var widget in ResultadosAnalisisClinicosv1) widget,
            //   ],
            // ),
            // const SizedBox(height: 16),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     for(var widget in ResultadosAnalisisCrlinicosv2) widget,
            //   ],
            // ),
            // const SizedBox(height: 16,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     for(var widget in ResultadosGeneticos) widget,
            //   ],
            // ),
            Text(
              description,
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.medical_services, color: Colors.black),
              label: const Text(
                "Doctores Disponibles",
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String value) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 70, // Limita el ancho al del círculo
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.white),
            maxLines: 1, // Limita el texto a una sola línea
            overflow: TextOverflow.visible, // Muestra "..."
          ),
        ),
      ],
    );
  }

}
