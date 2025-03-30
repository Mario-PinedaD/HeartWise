// ignore_for_file: avoid_print, non_constant_identifier_names, unused_element, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heartwise/view/resultados_screen.dart';
//import 'package:intl/intl.dart';

class AnalisisClinicoScreen extends StatefulWidget {
  const AnalisisClinicoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnalisisClinicoScreen createState() => _AnalisisClinicoScreen();
}

class _AnalisisClinicoScreen extends State<AnalisisClinicoScreen> {
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
  double? colesterol;
  double? trigliceridos;
  double? hdl;
  double? ldl;
  double? vldl;
  double? hcy;
  // ignore: non_constant_identifier_names
  double? hcy_level;

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
                        'Análisis Clínico Integral',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'El Análisis Clínico Integral proporciona una evaluación completa de los principales indicadores de salud, '
                            'incluyendo el funcionamiento de órganos, niveles de colesterol, glucosa, hormonas y más. '
                            'Este perfil es ideal para obtener una visión detallada del estado de salud general y detectar posibles '
                            'riesgos o alteraciones.',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          ElevatedButton.icon(
                            onPressed: () =>
                                _showInputDialog(context, "COL"),
                            //_mostrarDialog(context,"Altura", altura, "cm", onValueChanged: (newValue){setState(() {altura = newValue;});}),
                            icon: const Icon(
                              Icons.science,
                              color: Colors.white,
                            ),
                            label: Text(
                              colesterol == null ? "COL" : "$colesterol",
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
                            onPressed: () =>
                                _showInputDialog(context, "TRG"),
                            icon: const Icon(
                              Icons.science,
                              color: Colors.white,
                            ),
                            label: Text(
                              trigliceridos == null
                                  ? "TRG"
                                  : "$trigliceridos",
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
                                _showInputDialog(context, "HDL"),
                            //_mostrarDialog(context,"Altura", altura, "cm", onValueChanged: (newValue){setState(() {altura = newValue;});}),
                            icon: const Icon(
                              Icons.science,
                              color: Colors.white,
                            ),
                            label: Text(
                              hdl == null ? "HDL" : "$hdl",
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
                            onPressed: () =>
                                _showInputDialog(context, "LDL"),
                            icon: const Icon(
                              Icons.science,
                              color: Colors.white,
                            ),
                            label: Text(
                              ldl == null
                                  ? "LDL"
                                  : "$ldl",
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
                                _showInputDialog(context, "VLDL"),
                            //_mostrarDialog(context,"Altura", altura, "cm", onValueChanged: (newValue){setState(() {altura = newValue;});}),
                            icon: const Icon(
                              Icons.science,
                              color: Colors.white,
                            ),
                            label: Text(
                              vldl == null ? "VLDL" : "$vldl",
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
                            onPressed: () =>
                                _showInputDialog(context, "HCY"),
                            icon: const Icon(
                              Icons.science,
                              color: Colors.white,
                            ),
                            label: Text(
                              hcy == null
                                  ? "HCY"
                                  : "$hcy",
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
                                _showInputDialog(context, "Nivel de HCY"),
                            //_mostrarDialog(context,"Altura", altura, "cm", onValueChanged: (newValue){setState(() {altura = newValue;});}),
                            icon: const Icon(
                              Icons.science,
                              color: Colors.white,
                            ),
                            label: Text(
                              hcy_level == null ? "Nivel de HCY" : "$hcy_level",
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultadosScreen(dato1: "", dato2: "")));
                          /*print(edad);
                          print(genero);
                          print(peso);
                          print(altura);
                          print(musculo);
                          print(grasaT);
                          print(imc);
                          print(grasaVisc);
                          print(metabBasal);*/
                          print("ESTE ES EL RESULTADO DE LA REGRESION");
                          /*print(calcularRegresion(
                              edad!,
                              genero!,
                              peso!,
                              altura!,
                              musculo!,
                              grasaT!,
                              imc!,
                              grasaVisc!,
                              metabBasal!));*/
                          print("ESTE ES EL RESULTADO DE LA CLASIFICACION");
                          /*print(calcularClasificacion(
                              edad!,
                              genero!,
                              peso!,
                              altura!,
                              musculo!,
                              grasaT!,
                              imc!,
                              grasaVisc!,
                              metabBasal!));*/
                          edad = 18;
                          print(calcularClasificacionA2(edad!,
                              genero!,
                              peso!,
                              altura!,
                              musculo!,
                              grasaT!,
                              imc!,
                              grasaVisc!,
                              metabBasal!));
                          // para estos datos se utilizó el perfil numero 34 de: "DATA ANTRO-HEMA.csv"
                          print("===============================\n RESULTADO DE REGRESION ARBOL 2");
                          print(calcularResultado(
                              5,
                              101,
                              55,
                              41.4,
                              18,
                              1561.5,
                              156,
                              26.1,
                              96,
                              159,
                              1336));
                          print("Clasificacion Arbol 2");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
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
                    } else if (type == "Metabolismo") {
                      metabBasal = value;
                    } else if (type == "COL") {
                      colesterol = value;
                    } else if (type == "TRG") {
                      trigliceridos = value;
                    } else if (type == "HDL") {
                      hdl = value;
                    } else if (type == "LDL") {
                      ldl = value;
                    } else if (type == "VLDL") {
                      vldl = value;
                    } else if (type == "HCY") {
                      hcy = value;
                    } else {
                      hcy_level = value;
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

  double calcularRegresionA1(
      int Edad,
      int Genero,
      double Peso,
      double Talla,
      double Musculo,
      double GrasaT,
      double IMC,
      double GrasaVisceral,
      double MetabBasal) {
    if (IMC <= 31.14) {
      if (Musculo <= 43.71) {
        if (Peso <= 61.20) {
          if (IMC <= 17.51) {
            if (Musculo <= 28.42) {
              return 10.22126;
            } else {
              return 14.20329805;
            }
          } else {
            if (MetabBasal <= 1080.73) {
              return 8.10861737;
            } else {
              return 9.55598545;
            }
          }
        } else {
          if (Talla <= 158.00) {
            if (Genero <= 1.50) {
              return 9.71924446;
            } else {
              return 12.76163559;
            }
          } else {
            if (IMC <= 24.30) {
              return 10.13882596;
            } else {
              return 11.33274658;
            }
          }
        }
      } else {
        if (GrasaVisceral <= 4.82) {
          if (Peso <= 50.56) {
            return 15.78270056;
          } else {
            if (GrasaVisceral <= 3.04) {
              return 9.16494345;
            } else {
              return 12.04795312;
            }
          }
        } else {
          return 25.82548498;
        }
      }
    } else {
      if (Peso <= 69.00) {
        return 32.42158015;
      } else {
        if (GrasaVisceral <= 13.69) {
          if (Edad <= 21.48) {
            if (MetabBasal <= 1460.27) {
              return 13.4277745;
            } else {
              return 10.86314948;
            }
          } else {
            return 16.86646289;
          }
        } else {
          if (Peso <= 108.15) {
            if (Musculo <= 30.16) {
              return 16.72637142;
            } else {
              return 14.90399254;
            }
          } else {
            return 19.66379629;
          }
        }
      }
    }
  }

  List<double> calcularClasificacionA1(
      int Edad,
      int Sexo,
      double Peso,
      double Talla,
      double Musculo,
      double GrasaTotal,
      double IMC,
      double GrasaVisc,
      double MetabBasal) {
    if (Peso <= 64.81 && Talla <= 173.29) {
      if (Talla <= 154.95) {
        if (Peso <= 62.28) {
          if (Peso <= 56.46) {
            if (MetabBasal <= 1080.16) {
              return [1.0, 0.0, 0.0];
            } else {
              if (Talla <= 145.40) {
                return [1.0, 0.0, 0.0];
              } else {
                if (MetabBasal <= 1166.47) {
                  if (GrasaTotal <= 34.43) {
                    if (Edad <= 18.18) {
                      if (Peso <= 48.10) {
                        return [1.0, 0.0, 0.0];
                      } else {
                        if (GrasaTotal <= 31.90) {
                          return [0.25, 0.75, 0.0];
                        } else {
                          return [1.0, 0.0, 0.0];
                        }
                      }
                    } else {
                      if (Peso <= 45.63) {
                        if (Edad <= 20.50) {
                          return [0.0, 1.0, 0.0];
                        } else {
                          return [1.0, 0.0, 0.0];
                        }
                      } else {
                        if (Peso <= 49.25) {
                          if (Musculo <= 25.08) {
                            return [0.0, 1.0, 0.0];
                          } else {
                            if (MetabBasal <= 1158.86) {
                              return [1.0, 0.0, 0.0];
                            } else {
                              return [0.0, 1.0, 0.0];
                            }
                          }
                        } else {
                          return [0.0, 1.0, 0.0];
                        }
                      }
                    }
                  } else {
                    return [0.0, 1.0, 0.0];
                  }
                } else {
                  if (MetabBasal <= 1185.66) {
                    if (Talla <= 149.11) {
                      return [0.0, 1.0, 0.0];
                    } else {
                      if (Talla <= 152.75) {
                        return [1.0, 0.0, 0.0];
                      } else {
                        return [0.8, 0.2, 0.0];
                      }
                    }
                  } else {
                    if (MetabBasal <= 1196.25) {
                      return [0.0, 1.0, 0.0];
                    } else {
                      if (Talla <= 152.34) {
                        if (Talla <= 150.21) {
                          return [1.0, 0.0, 0.0];
                        } else {
                          return [0.0, 1.0, 0.0];
                        }
                      } else {
                        return [1.0, 0.0, 0.0];
                      }
                    }
                  }
                }
              }
            }
          } else {
            if (Edad <= 21.07) {
              if (IMC <= 27.86) {
                if (Talla <= 153.44) {
                  return [1.0, 0.0, 0.0];
                } else {
                  return [0.8, 0.2, 0.0];
                }
              } else {
                return [0.0, 1.0, 0.0];
              }
            } else {
              return [0.0, 0.0, 1.0];
            }
          }
        } else {
          if (GrasaVisc <= 5.56) return [0.0, 1.0, 0.0];
        }
      }
    }
    return [0.0, 0.0, 0.0]; // Valor por defecto
  }

  List<double> calcularClasificacionA2(
      int edad,
      int genero,
      double talla,
      double peso,
      double imc,
      double grasaT,
      double musculo,
      double metabBasal,
      double grasaVisc) {
    if (peso <= 64.81) {
      if (talla <= 173.29) {
        if (talla <= 154.95) {
          if (peso <= 62.28) {
            if (peso <= 56.46) {
              if (metabBasal <= 1080.16) {
                return [1.0, 0.0, 0.0];
              } else {
                if (talla <= 145.40) {
                  return [1.0, 0.0, 0.0];
                } else {
                  if (metabBasal <= 1166.47) {
                    if (grasaT <= 34.43) {
                      if (edad <= 18.18) {
                        if (peso <= 48.10) {
                          return [1.0, 0.0, 0.0];
                        } else {
                          if (grasaT <= 31.90) {
                            return [0.25, 0.75, 0.0];
                          } else {
                            return [1.0, 0.0, 0.0];
                          }
                        }
                      } else {
                        if (peso <= 45.63) {
                          if (edad <= 20.50) {
                            return [0.0, 1.0, 0.0];
                          } else {
                            return [1.0, 0.0, 0.0];
                          }
                        } else {
                          if (peso <= 49.25) {
                            if (musculo <= 25.08) {
                              return [0.0, 1.0, 0.0];
                            } else {
                              if (metabBasal <= 1158.86) {
                                return [1.0, 0.0, 0.0];
                              } else {
                                return [0.0, 1.0, 0.0];
                              }
                            }
                          } else {
                            return [0.0, 1.0, 0.0];
                          }
                        }
                      }
                    } else {
                      return [0.0, 1.0, 0.0];
                    }
                  } else {
                    if (metabBasal <= 1185.66) {
                      if (talla <= 149.11) {
                        return [0.0, 1.0, 0.0];
                      } else {
                        if (talla <= 152.75) {
                          return [1.0, 0.0, 0.0];
                        } else {
                          return [0.8, 0.2, 0.0];
                        }
                      }
                    } else {
                      if (metabBasal <= 1196.25) {
                        return [0.0, 1.0, 0.0];
                      } else {
                        if (talla <= 152.34) {
                          if (talla <= 150.21) {
                            return [1.0, 0.0, 0.0];
                          } else {
                            return [0.0, 1.0, 0.0];
                          }
                        } else {
                          return [1.0, 0.0, 0.0];
                        }
                      }
                    }
                  }
                }
              }
            } else {
              if (edad <= 21.07) {
                if (imc <= 27.86) {
                  if (talla <= 153.44) {
                    return [1.0, 0.0, 0.0];
                  } else {
                    return [0.8, 0.2, 0.0];
                  }
                } else {
                  return [0.0, 1.0, 0.0];
                }
              } else {
                return [0.0, 0.0, 1.0];
              }
            }
          } else {
            if (grasaVisc <= 5.56) {
              return [0.0, 1.0, 0.0];
            } else {
              return [0.75, 0.0, 0.25];
            }
          }
        } else {
          if (grasaVisc <= 4.01) {
            if (edad <= 19.65) {
              if (metabBasal <= 1185.53) {
                if (grasaT <= 29.78) {
                  if (peso <= 46.86) {
                    if (imc <= 17.82) {
                      return [0.0, 1.0, 0.0];
                    } else {
                      return [1.0, 0.0, 0.0];
                    }
                  } else {
                    return [0.0, 1.0, 0.0];
                  }
                } else {
                  if (metabBasal <= 1176.53) {
                    if (talla <= 162.58) {
                      return [1.0, 0.0, 0.0];
                    } else {
                      return [0.0, 0.0, 1.0];
                    }
                  } else {
                    return [0.0, 1.0, 0.0];
                  }
                }
              } else {
                if (imc <= 21.25) {
                  if (grasaVisc <= 2.24) {
                    if (grasaT <= 10.66) {
                      if (peso <= 50.56) {
                        return [0.0, 0.0, 1.0];
                      } else {
                        return [1.0, 0.0, 0.0];
                      }
                    } else {
                      if (imc <= 18.47) {
                        return [1.0, 0.0, 0.0];
                      } else {
                        if (edad <= 18.95) {
                          return [0.0, 1.0, 0.0];
                        } else {
                          return [1.0, 0.0, 0.0];
                        }
                      }
                    }
                  } else {
                    if (edad <= 18.63) {
                      if (musculo <= 25.40) {
                        return [0.0, 1.0, 0.0];
                      } else {
                        if (grasaT <= 28.17) {
                          return [1.0, 0.0, 0.0];
                        } else {
                          if (grasaT <= 28.45) {
                            return [0.0, 1.0, 0.0];
                          } else {
                            if (talla <= 161.48) {
                              return [0.66666667, 0.33333333, 0.0];
                            } else {
                              return [1.0, 0.0, 0.0];
                            }
                          }
                        }
                      }
                    } else {
                      if (grasaT <= 29.60) {
                        return [0.0, 0.75, 0.25];
                      } else {
                        return [1.0, 0.0, 0.0];
                      }
                    }
                  }
                } else {
                  if (peso <= 63.05) {
                    if (metabBasal <= 1315.25) {
                      if (metabBasal <= 1239.75) {
                        if (musculo <= 27.18) {
                          if (peso <= 55.50) {
                            if (metabBasal <= 1214.06) {
                              return [0.5, 0.5, 0.0];
                            } else {
                              return [1.0, 0.0, 0.0];
                            }
                          } else {
                            return [0.0, 1.0, 0.0];
                          }
                        } else {
                          return [0.0, 1.0, 0.0];
                        }
                      } else {
                        if (peso <= 61.40) {
                          if (musculo <= 21.90) {
                            return [0.0, 1.0, 0.0];
                          } else {
                            if (musculo <= 25.50) {
                              if (musculo <= 24.65) {
                                return [1.0, 0.0, 0.0];
                              } else {
                                return [0.33333333, 0.66666667, 0.0];
                              }
                            } else {
                              return [1.0, 0.0, 0.0];
                            }
                          }
                        } else {
                          return [0.0, 1.0, 0.0];
                        }
                      }
                    } else {
                      if (imc <= 21.50) {
                        return [1.0, 0.0, 0.0];
                      } else {
                        return [0.0, 1.0, 0.0];
                      }
                    }
                  } else {
                    return [1.0, 0.0, 0.0];
                  }
                }
              }
            } else {
              if (grasaT <= 27.13) {
                if (grasaVisc <= 2.54) {
                  return [1.0, 0.0, 0.0];
                } else {
                  return [0.0, 1.0, 0.0];
                }
              } else {
                return [1.0, 0.0, 0.0];
              }
            }
          } else {
            if (grasaVisc <= 5.13) {
              if (metabBasal <= 1574.53) {
                if (musculo <= 23.75) {
                  if (imc <= 24.11) {
                    return [1.0, 0.0, 0.0];
                  } else {
                    return [0.2, 0.6, 0.2];
                  }
                } else {
                  if (talla <= 166.60) {
                    if (musculo <= 43.33) {
                      if (imc <= 25.14) {
                        if (peso <= 57.21) {
                          return [0.0, 0.5, 0.5];
                        } else {
                          return [0.0, 1.0, 0.0];
                        }
                      } else {
                        if (imc <= 25.26) {
                          return [1.0, 0.0, 0.0];
                        } else {
                          if (grasaT <= 36.57) {
                            return [0.0, 0.0, 1.0];
                          } else {
                            return [0.0, 1.0, 0.0];
                          }
                        }
                      }
                    } else {
                      return [0.0, 0.0, 1.0];
                    }
                  } else {
                    return [0.25, 0.25, 0.5];
                  }
                }
              } else {
                return [0.6, 0.0, 0.4];
              }
            } else {
              return [1.0, 0.0, 0.0];
            }
          }
        }
      } else {
        if (genero <= 1.50) {
          return [0.0, 1.0, 0.0];
        } else {
          return [1.0, 0.0, 0.0];
        }
      }
    } else {
      if (grasaVisc <= 13.69) {
        if (grasaVisc <= 6.30) {
          if (grasaVisc <= 5.35) {
            if (peso <= 75.22) {
              if (musculo <= 23.65) {
                if (metabBasal <= 1300.40) {
                  return [0.0, 1.0, 0.0];
                } else {
                  if (edad <= 18.08) {
                    return [0.33333333, 0.66666667, 0.0];
                  } else {
                    return [1.0, 0.0, 0.0];
                  }
                }
              } else {
                if (imc <= 22.32) {
                  if (edad <= 17.52) {
                    return [0.0, 1.0, 0.0];
                  } else {
                    if (grasaVisc <= 3.30) {
                      return [0.33333333, 0.66666667, 0.0];
                    } else {
                      return [1.0, 0.0, 0.0];
                    }
                  }
                } else {
                  if (talla <= 154.51) {
                    return [0.66666667, 0.33333333, 0.0];
                  } else {
                    if (edad <= 17.89) {
                      return [0.25, 0.75, 0.0];
                    } else {
                      return [0.0, 1.0, 0.0];
                    }
                  }
                }
              }
            } else {
              if (musculo <= 28.44) {
                return [1.0, 0.0, 0.0];
              } else {
                return [0.0, 1.0, 0.0];
              }
            }
          } else {
            if (grasaT <= 49.05) {
              if (talla <= 162.36) {
                if (imc <= 30.86) {
                  if (genero <= 1.50) {
                    if (talla <= 157.04) {
                      if (talla <= 155.22) {
                        if (grasaVisc <= 6.18) {
                          return [1.0, 0.0, 0.0];
                        } else {
                          return [0.0, 1.0, 0.0];
                        }
                      } else {
                        return [0.25, 0.75, 0.0];
                      }
                    } else {
                      return [1.0, 0.0, 0.0];
                    }
                  } else {
                    return [0.0, 0.5, 0.5];
                  }
                } else {
                  if (grasaT <= 47.55) {
                    return [0.6, 0.4, 0.0];
                  } else {
                    return [0.0, 0.25, 0.75];
                  }
                }
              } else {
                if (grasaT <= 22.30) {
                  return [1.0, 0.0, 0.0];
                } else {
                  if (edad <= 18.19) {
                    if (grasaT <= 24.60) {
                      return [0.0, 1.0, 0.0];
                    } else {
                      if (grasaVisc <= 5.78) {
                        return [0.0, 1.0, 0.0];
                      } else {
                        return [0.8, 0.2, 0.0];
                      }
                    }
                  } else {
                    if (edad <= 21.62) {
                      return [0.0, 1.0, 0.0];
                    } else {
                      return [0.0, 0.0, 1.0];
                    }
                  }
                }
              }
            } else {
              return [0.0, 1.0, 0.0];
            }
          }
        } else {
          if (metabBasal <= 1338.39) {
            if (grasaT <= 46.12) {
              return [1.0, 0.0, 0.0];
            } else {
              return [0.0, 0.0, 1.0];
            }
          } else {
            if (peso <= 97.60) {
              if (peso <= 70.10) {
                if (metabBasal <= 1607.71) {
                  return [1.0, 0.0, 0.0];
                } else {
                  if (peso <= 69.63) {
                    return [0.0, 1.0, 0.0];
                  } else {
                    return [1.0, 0.0, 0.0];
                  }
                }
              } else {
                if (talla <= 187.69) {
                  if (grasaVisc <= 12.35) {
                    if (edad <= 21.48) {
                      if (grasaVisc <= 6.52) {
                        if (peso <= 79.18) {
                          return [0.0, 0.0, 1.0];
                        } else {
                          if (grasaT <= 44.26) {
                            return [1.0, 0.0, 0.0];
                          } else {
                            return [0.0, 1.0, 0.0];
                          }
                        }
                      } else {
                        if (peso <= 71.26) {
                          return [0.0, 0.75, 0.25];
                        } else {
                          return [0.0, 1.0, 0.0];
                        }
                      }
                    } else {
                      return [0.25, 0.5, 0.25];
                    }
                  } else {
                    return [0.5, 0.5, 0.0];
                  }
                } else {
                  return [1.0, 0.0, 0.0];
                }
              }
            } else {
              if (grasaVisc <= 12.64) {
                return [1.0, 0.0, 0.0];
              } else {
                return [0.0, 0.5, 0.5];
              }
            }
          }
        }
      } else {
        return [0.0, 0.0, 1.0];
      }
    }
  }
  double calcularResultado(
      double GrasaVisc,
      double LDL,
      double HDL,
      double GrasaT,
      int Edad,
      double VLDL,
      double COL,
      double IMC,
      double TRG,
      int Talla,
      double MetabBasal) {
    if (GrasaVisc <= 6.67) {
      if (LDL <= 118.60) {
        if (HDL <= 40.60) {
          if (GrasaT <= 15.12) {
            if (GrasaT <= 11.90) {
              return 14.20805581;
            } else {
              return 30.29230927;
            }
          } else {
            if (Edad <= 22.89) {
              return 10.09815813;
            } else {
              return 15.01008864;
            }
          }
        } else {
          if (HDL <= 65.93) {
            if (VLDL <= 10.57) {
              return 8.06817537;
            } else {
              return 9.39886183;
            }
          } else {
            if (Edad <= 19.99) {
              return 9.93822285;
            } else {
              return 14.34224368;
            }
          }
        }
      } else {
        if (COL <= 170.09) {
          if (HDL <= 59.09) {
            if (LDL <= 173.23) {
              return 12.20454813;
            } else {
              return 16.03877798;
            }
          } else {
            if (IMC <= 25.93) {
              return 16.2459585;
            } else {
              return 16.89511695;
            }
          }
        } else {
          if (HDL <= 46.74) {
            if (COL <= 216.16) {
              return 11.04634161;
            } else {
              return 14.44500265;
            }
          } else {
            if (TRG <= 141.80) {
              return 9.66680026;
            } else {
              return 11.42817259;
            }
          }
        }
      }
    } else {
      if (Talla <= 147.25) {
        return 31.96078842;
      } else {
        if (GrasaVisc <= 14.48) {
          if (LDL <= 170.89) {
            if (COL <= 202.26) {
              return 11.81004489;
            } else {
              return 16.16893524;
            }
          } else {
            if (GrasaT <= 19.22) {
              return 8.25113913;
            } else {
              return 7.95207139;
            }
          }
        } else {
          if (MetabBasal <= 2156.25) {
            if (GrasaT <= 39.85) {
              return 15.25364712;
            } else {
              return 16.48406277;
            }
          } else {
            return 21.76666667;
          }
        }
      }
    }
  }
}
