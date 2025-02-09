import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultadosScreen extends StatefulWidget {
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
      duration: Duration(milliseconds: 1000),
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
    return Scaffold(
      backgroundColor: Colors.red.shade700,
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "RESULTADOS",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    ScaleTransition(scale: _animation,
                    child: Image.asset('lib/sources/heart-black.png',
                      width: 50, height: 50, fit: BoxFit.contain, alignment: Alignment.bottomCenter,),)
                    ,
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Niveles de Homocisteína",
                          style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.bold)
                        ),
                        Text(
                          "15 µmol/L",
                          style: TextStyle(
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
            SizedBox(height: 16),
            Text(
              "Paciente",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Icon(Icons.person, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Abraham Carrasco Barradas",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Detalles de Resultados",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildResultCard("Grasa Total", "00"),
                _buildResultCard("Masa Muscular", "00"),
                _buildResultCard("Metabolismo Basal", "00"),
                _buildResultCard("Grasa Visceral", "00"),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Tu nivel de Homocisteína depende de la información introducida. De ser como resultado un valor alto, te recomendamos acudir a un médico para realizar pruebas más detalladas.",
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.medical_services, color: Colors.black),
              label: Text(
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: 70, // Limita el ancho al del círculo
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.white),
            maxLines: 1, // Limita el texto a una sola línea
            overflow: TextOverflow.visible, // Muestra "..."
          ),
        ),
      ],
    );
  }

}
