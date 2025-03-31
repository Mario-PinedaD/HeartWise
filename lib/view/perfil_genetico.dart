// ignore_for_file: non_constant_identifier_names, avoid_print, unused_element, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heartwise/service/database_service.dart';
import 'package:heartwise/view/resultados_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Widget principal para la pantalla de perfil genético
class PerfilGeneticoScreen extends StatefulWidget {
  // Propiedades
  final Map<String, dynamic>? userData; // Datos del usuario
  final String? tipoAnalisis; // Tipo de análisis a realizar

  // Constructor
  const PerfilGeneticoScreen({super.key, this.userData, this.tipoAnalisis});

  @override
  _PerfilGeneticoScreen createState() => _PerfilGeneticoScreen();
}

/// Estado del widget que maneja la lógica y UI
class _PerfilGeneticoScreen extends State<PerfilGeneticoScreen> {
  // Variables para datos personales
  DateTime? _fechaSeleccionada;
  int? edad; // Calculada: fecha actual - fecha nacimiento
  String? _selectedGender;
  int? genero; // 1 = Hombre | 2 = Mujer

  // Variables antropométricas
  double? peso; // En kilogramos
  double? altura; // En centímetros
  double? metabBasal; // Metabolismo basal
  double? grasaT; // Porcentaje de grasa total
  double? imc; // Índice de masa corporal
  double? grasaVisc; // Grasa visceral
  double? musculo; // Porcentaje de músculo

  // Variables de perfil lipídico
  double? colesterol; // Colesterol total
  double? trigliceridos;
  double? hdl; // Colesterol HDL (bueno)
  double? ldl; // Colesterol LDL (malo)
  double? vldl; // Colesterol VLDL
  double? hcy; // Homocisteína
  double? hcy_level; // Nivel de homocisteína

  // Variables genéticas
  double? alu; // Elementos ALU
  double? line; // Elementos LINE
  double? sat; // Elementos SAT

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDC3644),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Encabezado con información del paciente
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => (Navigator.pop(context)),
                      //Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Perfíl Genético Avanzado',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'El Perfil Genético Avanzado analiza el ADN y metabolismo para ofrecer una evaluación profunda de la salud a '
                      'nivel molecular. Este estudio se enfoca en la prevención de enfermedades, identificando predisposiciones '
                      'genéticas, respuestas a medicamentos y factores de riesgo hereditarios. Con esta información, podrá tomar '
                      'decisiones proactivas para optimizar el bienestar y prevenir condiciones de salud antes de que se manifiesten.',
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

              // Formulario de datos
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
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

                    // Sección de datos demográficos
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
                                _fechaSeleccionada == null
                                    ? 'Edad'
                                    : (DateTime.now()
                                            .difference(_fechaSeleccionada!)
                                            .inDays ~/
                                        365)
                                        .toString(),
                              ),
                            ],
                          ),
                        ),
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

                    // Sección de medidas antropométricas
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
                    const SizedBox(height: 20),

                    // Sección de composición corporal
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
                    const SizedBox(height: 20),

                    // Sección de análisis clínicos
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
                            grasaVisc == null ? "Grasa Visceral" : "$grasaVisc%",
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
                            metabBasal == null ? "Metabolismo" : "$metabBasal",
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _showInputDialog(context, "TRG"),
                          icon: const Icon(
                            Icons.science,
                            color: Colors.white,
                          ),
                          label: Text(
                            trigliceridos == null ? "TRG" : "$trigliceridos",
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _showInputDialog(context, "LDL"),
                          icon: const Icon(
                            Icons.science,
                            color: Colors.white,
                          ),
                          label: Text(
                            ldl == null ? "LDL" : "$ldl",
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
                    const SizedBox(height: 20),

                    // Sección de marcadores genéticos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _showInputDialog(context, "ALU"),
                          icon: const FaIcon(
                            FontAwesomeIcons.dna,
                            color: Colors.white,
                          ),
                          label: Text(
                            alu == null ? "ALU" : "$alu",
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
                          onPressed: () => _showInputDialog(context, "LINE"),
                          icon: const FaIcon(
                            FontAwesomeIcons.dna,
                            color: Colors.white,
                          ),
                          label: Text(
                            line == null ? "LINE" : "$line",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _showInputDialog(context, "SAT"),
                          icon: const FaIcon(
                            FontAwesomeIcons.dna,
                            color: Colors.white,
                          ),
                          label: Text(
                            sat == null ? "SAT" : "$sat",
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

                    // Botón de finalizar
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
                            "alu": alu,
                            "line": line,
                            "sat": sat,
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
                            "Alu": alu,
                            "Line": line,
                            "Sat": sat,
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

  /// Métodos auxiliares

  // Construye tarjetas informativas
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

  // Muestra diálogo para ingresar valores
  void _mostrarDialog(
    BuildContext context,
    String titulo,
    double variable,
    String unidad,
    ValueChanged<double> onValueChanged,
  ) {
    TextEditingController controller =
        TextEditingController(text: variable.toString());

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

  // Muestra diálogo personalizado para cada tipo de entrada
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
                    switch (type) {
                      case "Peso":
                        peso = value;
                        break;
                      case "Altura":
                        altura = value.toDouble();
                        break;
                      case "Músculo":
                        musculo = value;
                        break;
                      case "Grasa Total":
                        grasaT = value;
                        break;
                      case "IMC":
                        imc = value;
                        break;
                      case "Grasa Visceral":
                        grasaVisc = value;
                        break;
                      case "Metabolismo":
                        metabBasal = value;
                        break;
                      case "COL":
                        colesterol = value;
                        break;
                      case "TRG":
                        trigliceridos = value;
                        break;
                      case "HDL":
                        hdl = value;
                        break;
                      case "LDL":
                        ldl = value;
                        break;
                      case "VLDL":
                        vldl = value;
                        break;
                      case "ALU":
                        alu = value;
                        break;
                      case "LINE":
                        line = value;
                        break;
                      default:
                        sat = value;
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
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
