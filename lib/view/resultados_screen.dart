// ignore_for_file: library_private_types_in_public_api, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultadosScreen extends StatefulWidget {
  final String? dato1;
  final String? dato2;
  final String? correo;
  const ResultadosScreen({super.key, this.dato1, this.dato2, this.correo});

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

    if ("${widget.dato2}" == 'bajo') {
      description = "Tu nivel de homocisteína se encuentra dentro del rango bajo. Esto sugiere un bajo riesgo de problemas de salud relacionados con la homocisteína. Sin embargo, es importante mantener un estilo de vida saludable y realizar chequeos regulares.";
    } else if ("${widget.dato2}" == 'normal') {
      description = "Tu nivel de homocisteína está normal. Sin embargo, esto podría indicar un riesgo moderado de problemas de salud relacionados con la homocisteína. Se recomienda hablar con tu médico para discutir posibles causas y medidas preventivas.";
    } else if ("${widget.dato2}" == 'alto') {
      description = "Tu nivel de homocisteína es alto. Esto indica un riesgo significativo de problemas de salud relacionados con la homocisteína. Te recomendamos encarecidamente que consultes a tu médico para realizar pruebas adicionales y determinar el tratamiento adecuado.";
    } else {
      description = "Nivel de homocisteína desconocido."; // Manejar casos inesperados
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
      body: Padding(
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
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildResultCard("Grasa Total", "00"),
                _buildResultCard("Masa Muscular", "00"),
                _buildResultCard("Metabolismo Basal", "00"),
                _buildResultCard("Grasa Visceral", "00"),
              ],
            ),
            const SizedBox(height: 16),
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
