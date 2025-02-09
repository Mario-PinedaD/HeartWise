import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EvaluacionCorporalScreen extends StatefulWidget {
  @override
  _EvaluacionCorporalScreen createState() => _EvaluacionCorporalScreen();
}

class _EvaluacionCorporalScreen extends State<EvaluacionCorporalScreen> {
  DateTime? _fechaSeleccionada;
  String? _selectedGender;
  int? altura;
  int? peso;

  @override
  Widget build(BuildContext context) {
    double? screenAlto = MediaQuery.of(this.context).size.height;
    double screenAncho = MediaQuery.of(this.context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFDC3644),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón de regreso
                InkWell(
                  onTap: () => (), //Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Evaluación Corporal Básica',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'La Evaluación Corporal Básica ofrece un análisis esencial de los principales indicadores físicos y '
                        'de composición corporal del usuario. Este test es ideal para obtener una visión rápida y '
                        'sencilla del estado físico general. Con estos datos, el usuario puede comprender mejor '
                        'su composición física y recibir alertas tempranas sobre posibles riesgos de salud '
                        'relacionados con el peso o la grasa visceral.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Paciente',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Usuario Guapo Precioso',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Sección de ingreso de información
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    //borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Ingresa la información',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Fila de datos (Edad y Sexo)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2100));
                              if (pickedDate != null) { //antes estaba _fechaSeleecionada
                                setState(() {
                                  _fechaSeleccionada = pickedDate;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  _fechaSeleccionada == null
                                      ? 'Edad'
                                      : DateFormat('dd/MM/yyyy')
                                          .format(_fechaSeleccionada!),
                                ),
                              ],
                            ),

                          ),
                          TextButton(
                            onPressed: () {},
                            // No necesita acción aquí, el PopupMenuButton manejará el tap
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red, // Fondo rojo
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Bordes redondeados
                              ),
                            ),
                            child: PopupMenuButton<String>(
                              onSelected: (String newValue) {
                                setState(() {
                                  _selectedGender = newValue;
                                });
                              },
                              color: Colors.white,
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                    value: "Hombre", child: Text("Hombre")),
                                PopupMenuItem(
                                    value: "Mujer", child: Text("Mujer")),
                              ],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.male, color: Colors.white),
                                  // Icono en blanco
                                  SizedBox(width: 8),
                                  Text(
                                    _selectedGender ?? "Sexo",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // Texto en blanco
                                    ),
                                  ),
                                  Icon(Icons.arrow_drop_down,
                                      color: Colors.white),
                                  // Flecha blanca
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Fila de datos (Peso y Altura)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _showInputDialog(context,"Peso"),
                            icon: Icon(Icons.fitness_center,color: Colors.white,),
                            label: Text(
                              peso == null ? "Peso" : "${peso} kg",
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.bold,
                              color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showInputDialog(context,"Altura"),
                            icon: Icon(Icons.height,color: Colors.white,),
                            label: Text(
                                altura == null ? "Altura" : "${altura} cm",
                                style: GoogleFonts.poppins(fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Botón Finalizar
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 12),
                        ),
                        child: Text(
                          'Finalizar',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget reutilizable para las tarjetas de información
  Widget infoCard(IconData icon, String label, String value) {
    return Card(
      color: Colors.red[600],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              '$label $value',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showInputDialog(BuildContext context, String type) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ingrese su $type", style:
            GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.bold,), textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          content: TextField(
            controller: controller,
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold,),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: ""),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),),
            ),
            TextButton(
              onPressed: () {
                int? value = int.tryParse(controller.text);
                if (value != null && value >= 0 && value <= (type == 'Peso' ? 300 : 999)) {
                  setState(() {
                    if (type == "Peso") {
                      peso = value;
                    } else {
                      altura = value;
                    }
                  });
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
              ),
              child: Text("Aceptar", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

}
