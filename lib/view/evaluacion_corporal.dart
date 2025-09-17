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
  int? edad; // Calculada automáticamente
  int? genero; //1 = Hombre | 2 = Mujer
  double? peso; // Peso en kg
  double? altura; // Altura en cm

  // Estos serán calculados automáticamente
  double? metabBasal;
  double? grasaT;
  double? imc;
  double? grasaVisc;
  double? musculo;

  // Variables para marcar valores ingresados manualmente
  bool imcManual = false;
  bool grasaTManual = false;
  bool musculoManual = false;
  bool grasaViscManual = false;
  bool metabBasalManual = false;

  // Método para calcular IMC
  void _calcularIMC() {
    if (peso != null && altura != null) {
      double alturaM = altura! / 100; // Convertir cm a metros
      setState(() {
        imc = double.parse((peso! / (alturaM * alturaM)).toStringAsFixed(1));
      });
    }
  }

  // Método para calcular Metabolismo Basal (Fórmula de Harris-Benedict)
  void _calcularMetabolismoBasal() {
    if (peso != null && altura != null && edad != null && genero != null) {
      setState(() {
        if (genero == 1) {
          // Hombre
          metabBasal = double.parse(
              (88.362 + (13.397 * peso!) + (4.799 * altura!) - (5.677 * edad!))
                  .toStringAsFixed(0));
        } else {
          // Mujer
          metabBasal = double.parse(
              (447.593 + (9.247 * peso!) + (3.098 * altura!) - (4.330 * edad!))
                  .toStringAsFixed(0));
        }
      });
    }
  }

  // Método para estimar porcentaje de grasa corporal (Fórmula de Jackson-Pollock)
  void _calcularGrasaCorporal() {
    if (imc != null && edad != null && genero != null) {
      setState(() {
        if (genero == 1) {
          // Hombre
          grasaT = double.parse(
              ((1.20 * imc!) + (0.23 * edad!) - 16.2).toStringAsFixed(1));
        } else {
          // Mujer
          grasaT = double.parse(
              ((1.20 * imc!) + (0.23 * edad!) - 5.4).toStringAsFixed(1));
        }
        // Asegurar que no sea negativo
        if (grasaT! < 0) grasaT = 0;
      });
    }
  }

  // Método para estimar masa muscular
  void _calcularMasaMuscular() {
    if (peso != null && grasaT != null) {
      setState(() {
        double pesoGrasa = peso! * (grasaT! / 100);
        double pesoMagro = peso! - pesoGrasa;
        musculo = double.parse(((pesoMagro / peso!) * 100).toStringAsFixed(1));
      });
    }
  }

  // Método para estimar grasa visceral
  void _calcularGrasaVisceral() {
    if (imc != null && edad != null && genero != null) {
      setState(() {
        // Estimación basada en IMC y edad
        double factorEdad = edad! > 40 ? 1.2 : 1.0;
        double factorGenero = genero == 1 ? 1.1 : 1.0;

        if (imc! < 25) {
          grasaVisc =
              double.parse((2 * factorEdad * factorGenero).toStringAsFixed(1));
        } else if (imc! < 30) {
          grasaVisc =
              double.parse((5 * factorEdad * factorGenero).toStringAsFixed(1));
        } else {
          grasaVisc =
              double.parse((10 * factorEdad * factorGenero).toStringAsFixed(1));
        }
      });
    }
  }

  // Método para calcular todos los valores automáticamente
  void _calcularTodosLosValores() {
    _calcularIMC();
    _calcularMetabolismoBasal();
    _calcularGrasaCorporal();
    _calcularMasaMuscular();
    _calcularGrasaVisceral();
  }

  // Método para mostrar valores calculados con opción de entrada manual
  void _showCalculatedValueDialog(String field, double? value) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          field,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFDC3644),
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Valor calculado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDC3644).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFDC3644).withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    value != null ? Icons.auto_awesome : Icons.calculate,
                    color: const Color(0xFFDC3644),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Valor Calculado",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFDC3644),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value != null ? value.toString() : "Esperando...",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFDC3644),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    value != null ? Icons.info_outline : Icons.assignment,
                    color: Colors.blue.shade700,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      value != null
                          ? "También puedes ingresar tu propio valor si tienes datos externos"
                          : "Ingresa tu peso, altura y edad para calcular automáticamente",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Botón para entrada manual
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _showManualInputDialog(field, value ?? 0);
              },
              icon: const Icon(Icons.edit, size: 18),
              label: Text(
                "Ingresar Manualmente",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC3644),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Botón de entendido
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Entendido",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para permitir entrada manual de valores calculados
  void _showManualInputDialog(String field, double currentValue) {
    TextEditingController controller =
        TextEditingController(text: currentValue.toString());
    String unit = "";
    String hint = "";

    // Configurar unidad y hint según el campo
    switch (field) {
      case "Músculo":
      case "Grasa Total":
        unit = "%";
        hint = "Ej: 25.5";
        break;
      case "IMC":
        unit = "";
        hint = "Ej: 22.5";
        break;
      case "Grasa Visceral":
        unit = "";
        hint = "Ej: 8.0";
        break;
      case "Metabolismo":
        unit = "kcal/día";
        hint = "Ej: 1800";
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Column(
          children: [
            Icon(
              Icons.edit,
              color: const Color(0xFFDC3644),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              "Ingresar $field",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFDC3644),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mostrar valor actual calculado
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.grey.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Valor calculado: ",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    "$currentValue $unit",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Campo de entrada
            TextField(
              controller: controller,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFDC3644),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: hint,
                suffixText: unit,
                labelText: "Nuevo valor",
                labelStyle: GoogleFonts.poppins(
                  color: const Color(0xFFDC3644),
                  fontWeight: FontWeight.w600,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFFDC3644),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Ingrese el valor que obtuvo de su evaluación externa",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Botón de cancelar
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancelar",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Botón de actualizar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                double? newValue = double.tryParse(controller.text);
                if (newValue != null && newValue > 0) {
                  setState(() {
                    // Actualizar el valor según el campo
                    switch (field) {
                      case "Músculo":
                        musculo = newValue;
                        musculoManual = true;
                        break;
                      case "Grasa Total":
                        grasaT = newValue;
                        grasaTManual = true;
                        break;
                      case "IMC":
                        imc = newValue;
                        imcManual = true;
                        break;
                      case "Grasa Visceral":
                        grasaVisc = newValue;
                        grasaViscManual = true;
                        break;
                      case "Metabolismo":
                        metabBasal = newValue;
                        metabBasalManual = true;
                        break;
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "$field actualizado manualmente",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: const Color(0xFFDC3644),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Por favor, ingrese un valor válido",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.check, size: 18),
              label: Text(
                "Actualizar Valor",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC3644),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para validar si el formulario está completo
  bool _isFormValid() {
    return peso != null && altura != null;
  }

  // Método para finalizar la evaluación
  Future<void> _finalizarEvaluacion() async {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Por favor, complete peso y altura"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Obtener edad y género del userData con conversión de tipo segura
    var edadValue = widget.userData?['edad'];
    int userEdad = edadValue is int
        ? edadValue
        : (edadValue is String ? int.tryParse(edadValue) ?? 25 : 25);

    var generoValue = widget.userData?['genero'];
    int userGenero = generoValue is int
        ? generoValue
        : (generoValue is String
            ? int.tryParse(generoValue) ?? 1
            : 1); // 1 = hombre, 2 = mujer

    // Asignar valores para cálculos si no están definidos
    if (edad == null) edad = userEdad;
    if (genero == null) genero = userGenero;

    // Calcular valores automáticamente
    _calcularTodosLosValores();

    var resultado = await DatabaseService.enviarDatos01({
      "tipo": 1,
      "Genero": genero,
      "Edad": edad,
      "Talla": altura,
      "Peso": peso,
      "IMC": imc,
      "GrasaT": grasaT,
      "Musculo": musculo,
      "MetabBasal": metabBasal,
      "GrasaVisc": grasaVisc,
      "Correo": '${widget.userData?['correo']}',
      "FechaEjecucion": DateTime.now().toIso8601String(),
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

    if (resultado != null) {
      String dato1 = resultado['HCY'].toString();
      String dato2 = resultado['HCY_Level'].toString();
      print("Resultados: $resultado");

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultadosScreen(
                  dato1: dato1,
                  dato2: dato2,
                  dato3: widget.tipoAnalisis,
                  correo: widget.userData?['nombre'],
                  datosIngresados: datosIngresados,
                )),
      );
    } else {
      print("Error: No se recibieron datos de enviarDatos.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al procesar los datos.")),
      );
    }
  }

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
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 30),
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
                        'Análisis rápido de los principales indicadores físicos y composición corporal. '
                        'Obtén información esencial sobre tu estado físico y recibe alertas tempranas sobre posibles riesgos de salud.',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
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
                            '${widget.userData?['nombre'] ?? 'Usuario'}',
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
                const SizedBox(height: 5),

                // Cards compactas con datos básicos directamente en fondo rojo
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nota informativa como encabezado
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.4)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.analytics_outlined,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Biomarcadores • Los valores se calculan automáticamente o puedes ingresarlos manualmente',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.white,
                                  height: 1.3,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Cards compactas con datos básicos - Agrupación mejorada
                      Row(
                        children: [
                          _buildCompactDataCard(
                            peso == null ? "---" : "$peso kg",
                            "Peso",
                            Icons.monitor_weight,
                            () => _showInputDialog(context, "Peso"),
                          ),
                          const SizedBox(width: 8),
                          _buildCompactDataCard(
                            altura == null ? "---" : "$altura cm",
                            "Altura",
                            Icons.height,
                            () => _showInputDialog(context, "Talla"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildCompactDataCard(
                            musculo == null
                                ? "Completa datos básicos"
                                : "$musculo%",
                            "Masa Muscular",
                            Icons.fitness_center,
                            () =>
                                _showCalculatedValueDialog("Músculo", musculo),
                            isCalculated: true,
                            isManual: musculoManual,
                          ),
                          const SizedBox(width: 8),
                          _buildCompactDataCard(
                            grasaT == null
                                ? "Completa datos básicos"
                                : "$grasaT%",
                            "Grasa Total",
                            Icons.opacity,
                            () => _showCalculatedValueDialog(
                                "Grasa Total", grasaT),
                            isCalculated: true,
                            isManual: grasaTManual,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildCompactDataCard(
                            imc == null ? "Completa datos básicos" : "$imc",
                            "IMC",
                            Icons.assessment,
                            () => _showCalculatedValueDialog("IMC", imc),
                            isCalculated: true,
                            isManual: imcManual,
                          ),
                          const SizedBox(width: 8),
                          _buildCompactDataCard(
                            grasaVisc == null
                                ? "Completa datos básicos"
                                : "$grasaVisc",
                            "Grasa Visceral",
                            Icons.opacity_outlined,
                            () => _showCalculatedValueDialog(
                                "Grasa Visceral", grasaVisc),
                            isCalculated: true,
                            isManual: grasaViscManual,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Card individual para Metabolismo
                      _buildFullWidthDataCard(
                        metabBasal == null
                            ? "Completa datos básicos"
                            : "${metabBasal!.toStringAsFixed(0)} kcal/día",
                        "Metabolismo Basal",
                        Icons.local_fire_department,
                        () => _showCalculatedValueDialog(
                            "Metabolismo", metabBasal),
                        isCalculated: true,
                        isManual: metabBasalManual,
                      ),

                      const SizedBox(height: 24),

                      // Botón Finalizar
                      Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.grey.shade50,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFDC3644).withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isFormValid()
                              ? () async {
                                  await _finalizarEvaluacion();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            disabledBackgroundColor: Colors.grey.shade100,
                            foregroundColor: const Color(0xFFDC3644),
                            disabledForegroundColor: Colors.grey.shade400,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.analytics_rounded,
                                color: _isFormValid()
                                    ? const Color(0xFFDC3644)
                                    : Colors.grey.shade400,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Finalizar Evaluación',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _isFormValid()
                                      ? const Color(0xFFDC3644)
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
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

  void _showInputDialog(BuildContext context, String type) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Ingrese su $type",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: type == "Peso" ? "Ej: 70" : "Ej: 170",
                  suffixText: type == "Peso" ? "kg" : "cm",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: const Color(0xFFDC3644)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (type == "Peso" || type == "Talla" || type == "Altura")
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Los demás valores se calcularán automáticamente",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancelar",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                double? value = double.tryParse(controller.text);
                if (value != null && value > 0) {
                  setState(() {
                    if (type == "Peso") {
                      peso = value;
                      // Asignar edad y género del usuario si no están definidos
                      if (edad == null) {
                        var edadValue = widget.userData?['edad'];
                        edad = edadValue is int
                            ? edadValue
                            : (edadValue is String
                                ? int.tryParse(edadValue) ?? 25
                                : 25);
                      }
                      if (genero == null) {
                        var generoValue = widget.userData?['genero'];
                        genero = generoValue is int
                            ? generoValue
                            : (generoValue is String
                                ? int.tryParse(generoValue) ?? 1
                                : 1);
                      }
                      // Calcular valores automáticamente si ya tenemos altura
                      if (altura != null) {
                        _calcularTodosLosValores();
                      }
                    } else if (type == "Altura" || type == "Talla") {
                      altura = value;
                      // Asignar edad y género del usuario si no están definidos
                      if (edad == null) {
                        var edadValue = widget.userData?['edad'];
                        edad = edadValue is int
                            ? edadValue
                            : (edadValue is String
                                ? int.tryParse(edadValue) ?? 25
                                : 25);
                      }
                      if (genero == null) {
                        var generoValue = widget.userData?['genero'];
                        genero = generoValue is int
                            ? generoValue
                            : (generoValue is String
                                ? int.tryParse(generoValue) ?? 1
                                : 1);
                      }
                      // Calcular valores automáticamente si ya tenemos peso
                      if (peso != null) {
                        _calcularTodosLosValores();
                      }
                    }
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Por favor, ingrese un valor válido"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC3644),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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

  /// Widget para construir cards compactas de datos
  Widget _buildCompactDataCard(
    String value,
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isCalculated = false,
    bool isManual = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80, // Altura más compacta
          padding: const EdgeInsets.all(12), // Padding optimizado
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // Radio más pequeño
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06), // Sombra más sutil
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC3644).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      icon,
                      color: const Color(0xFFDC3644),
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: value.contains("Completa") || value.contains("---")
                          ? Colors.grey.shade400
                          : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (isCalculated)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color:
                        isManual ? Colors.orange.shade100 : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    isManual ? "Manual" : "Auto",
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      color: isManual
                          ? Colors.orange.shade700
                          : Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget para construir card de ancho completo
  Widget _buildFullWidthDataCard(
    String value,
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isCalculated = false,
    bool isManual = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80, // Altura consistente
        padding: const EdgeInsets.all(12), // Padding optimizado
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10), // Radio más pequeño
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06), // Sombra más sutil
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC3644).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFFDC3644),
                    size: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (isCalculated)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: isManual
                          ? Colors.orange.shade100
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      isManual ? "Manual" : "Auto",
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        color: isManual
                            ? Colors.orange.shade700
                            : Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: value.contains("Completa") || value.contains("---")
                        ? Colors.grey.shade400
                        : Colors.black87,
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
