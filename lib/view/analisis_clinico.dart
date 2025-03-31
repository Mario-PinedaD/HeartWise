// Desactivación de advertencias específicas para mantener el código limpio
// ignore_for_file: avoid_print, non_constant_identifier_names, unused_element, duplicate_ignore, use_build_context_synchronously

// Importaciones necesarias para el funcionamiento
import 'package:flutter/material.dart';           // Widgets base de Flutter
import 'package:google_fonts/google_fonts.dart';  // Fuentes de Google
import 'package:heartwise/service/database_service.dart';
import 'package:heartwise/view/resultados_screen.dart';  // Pantalla de resultados

/// Widget principal para la pantalla de análisis clínico
class AnalisisClinicoScreen extends StatefulWidget {
  // Propiedades de la clase
  final Map<String, dynamic>? userData;  // Datos del usuario (nombre, correo, etc.)
  final String? tipoAnalisis;           // Tipo de análisis a realizar

  // Constructor de la clase
  const AnalisisClinicoScreen({
    super.key, 
    this.userData, 
    this.tipoAnalisis
  });

  @override
  // Crea el estado mutable para este widget
  // ignore: library_private_types_in_public_api
  _AnalisisClinicoScreen createState() => _AnalisisClinicoScreen();
}

/// Estado del widget que maneja la lógica y la interfaz de usuario
class _AnalisisClinicoScreen extends State<AnalisisClinicoScreen> {
  // Variables para almacenar los datos ingresados por el usuario
  DateTime? _fechaSeleccionada;  // Fecha de nacimiento seleccionada
  int? edad;                     // Edad calculada a partir de la fecha de nacimiento
  String? _selectedGender;       // Género seleccionado ("Hombre" o "Mujer")
  int? genero;                   // 1 para Hombre, 2 para Mujer
  double? peso;                  // Peso en kilogramos
  double? altura;                // Altura en centímetros
  double? metabBasal;            // Metabolismo basal
  double? grasaT;                // Porcentaje de grasa total
  double? imc;                   // Índice de Masa Corporal
  double? grasaVisc;             // Grasa visceral
  double? musculo;               // Porcentaje de masa muscular
  double? colesterol;            // Nivel de colesterol
  double? trigliceridos;         // Nivel de triglicéridos
  double? hdl;                   // Colesterol HDL (colesterol "bueno")
  double? ldl;                   // Colesterol LDL (colesterol "malo")
  double? vldl;                  // Colesterol VLDL
  double? hcy;                   // Nivel de homocisteína
  // ignore: non_constant_identifier_names
  double? hcy_level;             // Nivel de riesgo de homocisteína

  @override
  Widget build(BuildContext context) {
    // Diseño de la pantalla
    return Scaffold(
      backgroundColor: const Color(0xFFDC3644),  // Fondo rojo
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botón de regreso a la pantalla anterior
              InkWell(
                onTap: () => (Navigator.pop(context)),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 8),

              // Sección de encabezado con título y descripción
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
                          '${widget.userData?['nombre'] ?? 'Nombre'}',  // Nombre del paciente (temporal)
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

              // Sección principal para ingresar la información del usuario
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
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

                    // Fila para ingresar la edad y el género
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botón para seleccionar la fecha de nacimiento y calcular la edad
                        ElevatedButton(
                          onPressed: () async {
                            // Abre el selector de fecha
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2100));

                            // Si se seleccionó una fecha, actualiza el estado
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
                                // Muestra la edad calculada o "Edad" si no se ha seleccionado la fecha
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

                        // Botón para seleccionar el género
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: PopupMenuButton<String>(
                            onSelected: (String newValue) {
                              setState(() {
                                _selectedGender = newValue;
                                genero = (_selectedGender == "Hombre") ? 1 : 2;
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
                                const SizedBox(width: 8),
                                Text(
                                  _selectedGender ?? "Sexo",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Fila para ingresar el peso y la altura
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botón para ingresar el peso
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

                        // Botón para ingresar la altura
                        ElevatedButton.icon(
                          onPressed: () => _showInputDialog(context, "Altura"),
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
                        // Botón para ingresar el porcentaje de músculo
                        ElevatedButton.icon(
                          onPressed: () => _showInputDialog(context, "Músculo"),
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

                        // Botón para ingresar el porcentaje de grasa total
                        ElevatedButton.icon(
                          onPressed: () => _showInputDialog(context, "Grasa Total"),
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

                    // CUARTA FILA (IMC Y GRASA VISCERAL)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botón para ingresar el IMC
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

                        // Botón para ingresar la grasa visceral
                        ElevatedButton.icon(
                          onPressed: () => _showInputDialog(context, "Grasa Visceral"),
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

                    // QUINTA FILA (METABOLISMO Y COLESTEROL)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botón para ingresar el metabolismo basal
                        ElevatedButton.icon(
                          onPressed: () => _showInputDialog(context, "Metabolismo"),
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

                        // Botón para ingresar el colesterol
                        ElevatedButton.icon(
                          onPressed: () => _showInputDialog(context, "COL"),
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

                    // SEXTA FILA (TRIGLICERIDOS Y HDL)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botón para ingresar los triglicéridos
                        ElevatedButton.icon(
                          onPressed: () => _showInputDialog(context, "TRG"),
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

                        // Botón para ingresar el colesterol HDL
                        ElevatedButton.icon(
                          onPressed: () => _showInputDialog(context, "HDL"),
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

                    // SÉPTIMA FILA (LDL Y VLDL)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botón para ingresar el colesterol LDL
                        ElevatedButton.icon(
                          onPressed: () => _showInputDialog(context, "LDL"),
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

                        // Botón para ingresar el colesterol VLDL
                        ElevatedButton.icon(
                          onPressed: () => _showInputDialog(context, "VLDL"),
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
                    const SizedBox(height: 20),

                    // Botón Finalizar
                    ElevatedButton(
                      onPressed: () async {
                        var resultado = await DatabaseService.enviarDatos01({
                            "Genero": genero,
                            "Edad": edad,
                            "Talla": altura,
                            "Peso": peso,
                            "IMC": imc,
                            "GrasaT": grasaT,
                            "Musculo": musculo,
                            "MetabBasal": metabBasal,
                            "GrasaVisc": grasaVisc,
                            "Colesterol": colesterol,
                            "Trigliceridos": trigliceridos,
                            "Hdl": hdl,
                            "Ldl": ldl,
                            "Vldl": vldl,
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
                            "Colesterol": colesterol,
                            "Trigliceridos": trigliceridos,
                            "Hdl": hdl,
                            "Ldl": ldl,
                            "Vldl": vldl,
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

  /// Muestra un diálogo para ingresar un valor numérico
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

  /// Muestra un diálogo personalizado para ingresar diferentes tipos de datos
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
                    // Actualiza la variable correspondiente según el tipo de dato
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
}