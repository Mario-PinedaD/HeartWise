// ignore_for_file: avoid_print, unused_element, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heartwise/view/resultados_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:heartwise/service/database_service.dart';
//import 'package:intl/intl.dart';

class EvaluacionCorporalScreen extends StatefulWidget {

  // Constructor que recibe un Map de datos del usuario
  final Map<String, dynamic>? userData;
  final String? tipoAnalisis;
  const EvaluacionCorporalScreen({super.key, this.userData, this.tipoAnalisis});

  @override
  // ignore: library_private_types_in_public_api
  _EvaluacionCorporalScreen createState() => _EvaluacionCorporalScreen();
}

class _EvaluacionCorporalScreen extends State<EvaluacionCorporalScreen> {
  DateTime? _fechaSeleccionada;
  int?
      edad; // Esta será calcularda con: Fecha nacimiento - fecha actual (obteniendo solo el año)
  String? _selectedGender;
  int? genero; //1 = Hombre | 2 = Mujer
  double? peso; //Peso, no sabes leer o q?
  double? altura; //Es lo mismo que 'Talla'
  //Estos son para comenzar con los análisis y predicciones:
  double? metabBasal;
  double? grasaT;
  double? imc;
  double? grasaVisc;
  double? musculo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDC3644),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón de regreso
                InkWell(
                  onTap: () => (Navigator.pop(context)),
                  //Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
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
                          const Icon(Icons.person, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.userData?['nombre'] ?? 'Nombre'}',
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
                              if (pickedDate != null) {
                                //antes estaba _fechaSeleecionada
                                setState(() {
                                  _fechaSeleccionada = pickedDate;
                                  edad = DateTime.now()
                                          .difference(_fechaSeleccionada!)
                                          .inDays ~/
                                      365;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  /*Ahora lo que hace es obtener la diferencia entre las 2 fechas
                                   Lo divide entre los días y puede obtener con precisión los años
                                   Habría que compararla con la edad del usuario para sustituir la _fechaSeleccionada
                                   con la fecha del usuario a la hora de registrarse
                                  */
                                  _fechaSeleccionada == null
                                      ? 'Edad'
                                      : (DateTime.now()
                                                  .difference(
                                                      _fechaSeleccionada!)
                                                  .inDays ~/
                                              365)
                                          .toString(),
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
                                  if (_selectedGender == "Hombre") {
                                    genero = 1;
                                  } else {
                                    genero = 2;
                                  }
                                });
                              },
                              color: Colors.white,
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem(
                                    value: "Hombre", child: Text("Hombre")),
                                const PopupMenuItem(
                                    value: "Mujer", child: Text("Mujer")),
                              ],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.male, color: Colors.white),
                                  // Icono en blanco
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedGender ?? "Sexo",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // Texto en blanco
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down,
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
                            onPressed: () => _showInputDialog(context, "Peso"),
                            icon: const Icon(
                              Icons.scale,
                              color: Colors.white,
                            ),
                            label: Text(
                              peso == null ? "Peso" : "$peso kg",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
                            onPressed: () =>
                                _showInputDialog(context, "Altura"),
                                //_mostrarDialog(context,"Altura", altura, "cm", onValueChanged: (newValue){setState(() {altura = newValue;});}),
                            icon: const Icon(
                              Icons.height,
                              color: Colors.white,
                            ),
                            label: Text(
                              altura == null ? "Altura" : "$altura cm",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // TERCER FILA (METABOLISMO Y GRASA TOTAL)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () =>
                                _showInputDialog(context, "Músculo"),
                            icon: const Icon(
                              Icons.fitness_center_rounded,
                              color: Colors.white,
                            ),
                            label: Text(
                              musculo == null ? "Músculo" : "$musculo%",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
                            onPressed: () =>
                                _showInputDialog(context, "Grasa Total"),
                            icon: const Icon(
                              Icons.opacity,
                              color: Colors.white,
                            ),
                            label: Text(
                              grasaT == null ? "Grasa" : "$grasaT%",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _showInputDialog(context, "IMC"),
                            icon: const Icon(
                              Icons.monitor_weight,
                              color: Colors.white,
                            ),
                            label: Text(
                              imc == null ? "IMC" : "$imc",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
                            onPressed: () =>
                                _showInputDialog(context, "Grasa Visceral"),
                            icon: const Icon(
                              Icons.opacity_outlined,
                              color: Colors.white,
                            ),
                            label: Text(
                              grasaVisc == null
                                  ? "Grasa Visceral"
                                  : "$grasaVisc%",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () =>
                                _showInputDialog(context, "Metabolismo"),
                            icon: const Icon(
                              Icons.local_fire_department,
                              color: Colors.white,
                            ),
                            label: Text(
                              metabBasal == null
                                  ? "Metabolismo"
                                  : "$metabBasal",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
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
                        onPressed: () async {
                          var resultado = await DatabaseService.enviarDatos01({
                            "tipo": 1,
                            "Genero": 1,
                            "Edad": 19,
                            "Talla": 161,
                            "Peso": 59.8,
                            "IMC": 23.1,
                            "GrasaT": 37.1,
                            "Musculo": 25.1,
                            "MetabBasal": 1285.5,
                            "GrasaVisc": 4,
                            // "Colesterol": 159,
                            // "Trigliceridos": 41,
                            // "Hdl": 36,
                            // "Ldl": 50,
                            // "Vldl": 1658,
                            // "alu": 49,
                            // "line": 38,
                            // "sat": 81,
                            "Correo": '${widget.userData?['correo']}',
                          });

                          var datosIngresados = {
                            "Genero": genero,
                            "Edad": edad,
                            "Talla": altura,
                            "Peso": peso,
                            "IMC": imc,
                            "GrasaT": grasaT,
                            "Musculo": musculo,
                            "MetabBasal": metabBasal,
                            "GrasaVisc": grasaVisc,
                          };

                          // Verifica si la función enviarDatos devolvió un resultado exitoso (JSON no nulo)
                          if (resultado != null) {
                            // Extrae los datos que necesitas del JSON
                            String dato1 = resultado['HCY'].toString(); // Reemplaza 'dato1' con la clave real del primer dato
                            String dato2 = resultado['HCY_Level'].toString(); // Reemplaza 'dato2' con la clave real del segundo dato
                            print("Resultados: $resultado");

                            // Navega a la pantalla ResultadosScreen y pasa los datos
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ResultadosScreen(dato1: dato1, dato2: dato2, dato3: widget.tipoAnalisis, correo: widget.userData?['nombre'], datosIngresados: datosIngresados,)),
                            );
                          } else {
                            // Maneja el caso en que la función enviarDatos no devolvió datos (opcional)
                            print("Error: No se recibieron datos de enviarDatos.");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error al procesar los datos.")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                        ),
                        child: Text(
                          'Finalizar',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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

  void _mostrarDialog(
    BuildContext context,
    String titulo,
    double variable,
    String unidad,
    ValueChanged<double> onValueChanged,
  ) {
    TextEditingController controller = TextEditingController(text: variable.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Ingrese: $titulo ($unidad)",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          content: TextField(
            controller: controller,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Ingrese el valor"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancelar",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                double? value = double.tryParse(controller.text);
                if (value != null && value >= 0) {
                  onValueChanged(value);
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                "Aceptar",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showInputDialog(BuildContext context, String type) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Ingrese su $type",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          content: TextField(
            controller: controller,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: ""),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancelar",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                double? value = double.tryParse(controller.text);
                if (value != null && value >= 0) {
                  setState(() {
                    if (type == "Peso") {
                      peso = value;
                    } else if (type == "Altura") {
                      altura = value.toDouble();
                    } else if (type == "Músculo") {
                      musculo = value;
                    } else if (type == "Grasa Total") {
                      grasaT = value;
                    } else if (type == "IMC") {
                      imc = value;
                    } else if (type == "Grasa Visceral") {
                      grasaVisc = value;
                    } else {
                      metabBasal = value;
                    }
                  });
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                "Aceptar",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}