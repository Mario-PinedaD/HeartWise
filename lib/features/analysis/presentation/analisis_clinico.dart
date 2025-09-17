import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heartwise/service/database_service.dart';
import 'package:heartwise/features/results/presentation/resultados_screen.dart';

class AnalisisClinicoScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final String tipoAnalisis;

  const AnalisisClinicoScreen(
      {super.key, this.userData, required this.tipoAnalisis});

  @override
  State<AnalisisClinicoScreen> createState() => _AnalisisClinicoScreenState();
}

class _AnalisisClinicoScreenState extends State<AnalisisClinicoScreen> {
  // Variables básicas para cálculos
  double? peso;
  double? altura;
  int? edad;
  int? genero;

  // Variables calculadas automáticamente
  double? imc;
  double? metabolismoBasal;
  double? masaMuscular;
  double? grasaTotal;
  double? grasaVisceral;
  double? vldl;
  double? ldl;

  // Variables de entrada directa (análisis clínico)
  double? trigliceridos;
  double? hdl;
  double? colesterolTotal;
  double? glucosa;
  double? hemoglobina;
  double? hematocrito;
  double? presionSistolica;
  double? presionDiastolica;

  // Variables para rastrear entrada manual vs automática
  bool imcManual = false;
  bool metabolismoBasalManual = false;
  bool masaMuscularManual = false;
  bool grasaTotalManual = false;
  bool grasaVisceralManual = false;
  bool vldlManual = false;
  bool ldlManual = false;

  // Método para calcular IMC automáticamente
  void _calcularIMC() {
    if (peso != null && altura != null && !imcManual) {
      setState(() {
        double alturaEnMetros = altura! / 100.0;
        imc = peso! / (alturaEnMetros * alturaEnMetros);
      });
    }
  }

  // Método para calcular Metabolismo Basal (Harris-Benedict)
  void _calcularMetabolismoBasal() {
    if (peso != null &&
        altura != null &&
        edad != null &&
        genero != null &&
        !metabolismoBasalManual) {
      setState(() {
        if (genero == 1) {
          // Hombre
          metabolismoBasal =
              88.362 + (13.397 * peso!) + (4.799 * altura!) - (5.677 * edad!);
        } else {
          // Mujer
          metabolismoBasal =
              447.593 + (9.247 * peso!) + (3.098 * altura!) - (4.330 * edad!);
        }
      });
    }
  }

  // Método para calcular VLDL automáticamente
  void _calcularVLDL() {
    if (trigliceridos != null && !vldlManual) {
      setState(() {
        vldl = trigliceridos! / 5;
      });
    }
  }

  // Método para calcular LDL automáticamente (Fórmula de Friedewald)
  void _calcularLDL() {
    if (colesterolTotal != null &&
        hdl != null &&
        trigliceridos != null &&
        !ldlManual) {
      setState(() {
        ldl = colesterolTotal! - hdl! - (trigliceridos! / 5);
      });
    }
  }

  // Método para calcular Masa Muscular automáticamente
  void _calcularMasaMuscular() {
    if (peso != null &&
        altura != null &&
        edad != null &&
        genero != null &&
        !masaMuscularManual) {
      setState(() {
        if (genero == 1) {
          // Hombre
          masaMuscular =
              (0.407 * peso!) + (0.267 * altura!) - (0.049 * edad!) + 8.8;
        } else {
          // Mujer
          masaMuscular =
              (0.252 * peso!) + (0.473 * altura!) - (0.048 * edad!) + 0.4;
        }
        // Convertir a porcentaje
        masaMuscular = (masaMuscular! / peso!) * 100;
      });
    }
  }

  // Método para calcular Grasa Total automáticamente
  void _calcularGrasaTotal() {
    if (peso != null &&
        altura != null &&
        edad != null &&
        genero != null &&
        !grasaTotalManual) {
      setState(() {
        double alturaEnMetros = altura! / 100.0;
        double imc_calc = peso! / (alturaEnMetros * alturaEnMetros);

        if (genero == 1) {
          // Hombre
          grasaTotal = (1.20 * imc_calc) + (0.23 * edad!) - 16.2;
        } else {
          // Mujer
          grasaTotal = (1.20 * imc_calc) + (0.23 * edad!) - 5.4;
        }

        // Asegurar que esté en rango válido
        if (grasaTotal! < 0) grasaTotal = 0;
        if (grasaTotal! > 50) grasaTotal = 50;
      });
    }
  }

  // Método para calcular Grasa Visceral automáticamente
  void _calcularGrasaVisceral() {
    if (peso != null &&
        altura != null &&
        edad != null &&
        genero != null &&
        !grasaVisceralManual) {
      setState(() {
        double alturaEnMetros = altura! / 100.0;
        double imc_calc = peso! / (alturaEnMetros * alturaEnMetros);

        if (genero == 1) {
          // Hombre
          grasaVisceral = (edad! / 2) + (imc_calc / 3) - 10;
        } else {
          // Mujer
          grasaVisceral = (edad! / 2.5) + (imc_calc / 3.5) - 8;
        }

        // Asegurar que esté en rango válido (1-30)
        if (grasaVisceral! < 1) grasaVisceral = 1;
        if (grasaVisceral! > 30) grasaVisceral = 30;
      });
    }
  }

  // Método para calcular todos los valores automáticamente
  void _calcularTodosLosValores() {
    _calcularIMC();
    _calcularMetabolismoBasal();
    _calcularMasaMuscular();
    _calcularGrasaTotal();
    _calcularGrasaVisceral();
    _calcularVLDL();
    _calcularLDL();
  }

  // Método para mostrar diálogo de valor calculado
  void _showCalculatedValueDialog(String field, double? value) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          field,
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
            Text(
              value != null
                  ? "Valor calculado automáticamente"
                  : "Valor no disponible",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            if (value != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value.toStringAsFixed(field == "IMC" ? 1 : 0),
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
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
                          : "Ingresa los datos requeridos para calcular automáticamente",
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
      case "IMC":
        unit = "";
        hint = "Ej: 22.5";
        break;
      case "Metabolismo Basal":
        unit = "kcal/día";
        hint = "Ej: 1500";
        break;
      case "Masa Muscular":
        unit = "%";
        hint = "Ej: 25.5";
        break;
      case "Grasa Total":
        unit = "%";
        hint = "Ej: 18.0";
        break;
      case "Grasa Visceral":
        unit = "";
        hint = "Ej: 8.0";
        break;
      case "VLDL":
      case "LDL":
        unit = "mg/dL";
        hint = "Ej: 120";
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Ingresar $field manualmente",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: hint,
                suffixText: unit,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: const Color(0xFFDC3644)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Este valor ya no se calculará automáticamente",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.orange.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancelar",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              double? value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                setState(() {
                  switch (field) {
                    case "IMC":
                      imc = value;
                      imcManual = true;
                      break;
                    case "Metabolismo Basal":
                      metabolismoBasal = value;
                      metabolismoBasalManual = true;
                      break;
                    case "Masa Muscular":
                      masaMuscular = value;
                      masaMuscularManual = true;
                      break;
                    case "Grasa Total":
                      grasaTotal = value;
                      grasaTotalManual = true;
                      break;
                    case "Grasa Visceral":
                      grasaVisceral = value;
                      grasaVisceralManual = true;
                      break;
                    case "VLDL":
                      vldl = value;
                      vldlManual = true;
                      break;
                    case "LDL":
                      ldl = value;
                      ldlManual = true;
                      break;
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
      ),
    );
  }

  // Método para validar si el formulario está completo (solo requiere peso y altura)
  bool _isFormValid() {
    return peso != null && altura != null;
  }

  // Método para finalizar el análisis
  Future<void> _finalizarAnalisis() async {
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
      "tipo": 2,
      "Genero": genero,
      "Edad": edad,
      "Talla": altura,
      "Peso": peso,
      "IMC": imc,
      "GrasaT": grasaTotal,
      "Musculo": masaMuscular,
      "MetabBasal": metabolismoBasal,
      "GrasaVisc": grasaVisceral,
      "COL": colesterolTotal,
      "TRG": trigliceridos,
      "HDL": hdl,
      "LDL": ldl,
      "VLDL": vldl,
      "GLU": glucosa,
      "HGB": hemoglobina,
      "HCT": hematocrito,
      "SBP": presionSistolica,
      "DBP": presionDiastolica,
      "Correo": '${widget.userData?['correo']}',
      "FechaEjecucion": DateTime.now().toIso8601String(),
    });

    var datosIngresados = {
      "Genero": genero,
      "Edad": edad,
      "Talla": altura,
      "Peso": peso,
      "IMC": imc,
      "GrasaT": grasaTotal,
      "Musculo": masaMuscular,
      "MetabBasal": metabolismoBasal,
      "GrasaVisc": grasaVisceral,
      "COL": colesterolTotal,
      "TRG": trigliceridos,
      "HDL": hdl,
      "LDL": ldl,
      "VLDL": vldl,
      "GLU": glucosa,
      "HGB": hemoglobina,
      "HCT": hematocrito,
      "SBP": presionSistolica,
      "DBP": presionDiastolica,
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
                  onTap: () => Navigator.pop(context),
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
                        'Análisis Clínico Completo',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Análisis exhaustivo de biomarcadores clínicos, perfil lipídico y marcadores metabólicos. '
                        'Evaluación integral de tu estado de salud con interpretación automática de resultados.',
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
                      // 1. DATOS BÁSICOS FÍSICOS
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
                            () => _showInputDialog(context, "Altura"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // 2. INDICADORES CORPORALES CALCULADOS
                      Row(
                        children: [
                          _buildCompactDataCard(
                            imc == null
                                ? "Completa datos básicos"
                                : imc!.toStringAsFixed(1),
                            "IMC",
                            Icons.assessment,
                            () => _showCalculatedValueDialog("IMC", imc),
                            isCalculated: true,
                            isManual: imcManual,
                          ),
                          const SizedBox(width: 8),
                          _buildCompactDataCard(
                            metabolismoBasal == null
                                ? "Completa datos básicos"
                                : "${metabolismoBasal!.toStringAsFixed(0)} kcal",
                            "Metabolismo Basal",
                            Icons.local_fire_department,
                            () => _showCalculatedValueDialog(
                                "Metabolismo Basal", metabolismoBasal),
                            isCalculated: true,
                            isManual: metabolismoBasalManual,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildCompactDataCard(
                            masaMuscular == null
                                ? "Completa datos básicos"
                                : "${masaMuscular!.toStringAsFixed(1)}%",
                            "Masa Muscular",
                            Icons.fitness_center,
                            () => _showCalculatedValueDialog(
                                "Masa Muscular", masaMuscular),
                            isCalculated: true,
                            isManual: masaMuscularManual,
                          ),
                          const SizedBox(width: 8),
                          _buildCompactDataCard(
                            grasaTotal == null
                                ? "Completa datos básicos"
                                : "${grasaTotal!.toStringAsFixed(1)}%",
                            "Grasa Total",
                            Icons.opacity,
                            () => _showCalculatedValueDialog(
                                "Grasa Total", grasaTotal),
                            isCalculated: true,
                            isManual: grasaTotalManual,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildCompactDataCard(
                            grasaVisceral == null
                                ? "Completa datos básicos"
                                : grasaVisceral!.toStringAsFixed(1),
                            "Grasa Visceral",
                            Icons.opacity_outlined,
                            () => _showCalculatedValueDialog(
                                "Grasa Visceral", grasaVisceral),
                            isCalculated: true,
                            isManual: grasaVisceralManual,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Container()), // Espacio vacío para centrar
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Separador para perfil lipídico
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
                            Icon(Icons.favorite_border,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Perfil Lipídico • Colesterol y triglicéridos',
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
                      const SizedBox(height: 16),

                      // 3. PERFIL LIPÍDICO COMPLETO
                      Row(
                        children: [
                          _buildCompactDataCard(
                            colesterolTotal == null
                                ? "---"
                                : "$colesterolTotal mg/dL",
                            "Colesterol Total",
                            Icons.circle,
                            () => _showInputDialog(context, "Colesterol Total"),
                          ),
                          const SizedBox(width: 8),
                          _buildCompactDataCard(
                            trigliceridos == null
                                ? "---"
                                : "$trigliceridos mg/dL",
                            "Triglicéridos",
                            Icons.water_drop,
                            () => _showInputDialog(context, "Triglicéridos"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildCompactDataCard(
                            hdl == null ? "---" : "$hdl mg/dL",
                            "HDL",
                            Icons.favorite,
                            () => _showInputDialog(context, "HDL"),
                          ),
                          const SizedBox(width: 8),
                          _buildCompactDataCard(
                            ldl == null
                                ? "Completa datos"
                                : "${ldl!.toStringAsFixed(0)} mg/dL",
                            "LDL",
                            Icons.coronavirus,
                            () => _showCalculatedValueDialog("LDL", ldl),
                            isCalculated: true,
                            isManual: ldlManual,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildCompactDataCard(
                            vldl == null
                                ? "Completa datos"
                                : "${vldl!.toStringAsFixed(0)} mg/dL",
                            "VLDL",
                            Icons.bubble_chart,
                            () => _showCalculatedValueDialog("VLDL", vldl),
                            isCalculated: true,
                            isManual: vldlManual,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Container()), // Espacio vacío
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Separador para otros biomarcadores
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
                            Icon(Icons.biotech, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Otros Biomarcadores • Glucosa y hematología',
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
                      const SizedBox(height: 16),

                      // 4. OTROS BIOMARCADORES
                      Row(
                        children: [
                          _buildCompactDataCard(
                            glucosa == null ? "---" : "$glucosa mg/dL",
                            "Glucosa",
                            Icons.healing,
                            () => _showInputDialog(context, "Glucosa"),
                          ),
                          const SizedBox(width: 8),
                          _buildCompactDataCard(
                            hemoglobina == null ? "---" : "$hemoglobina g/dL",
                            "Hemoglobina",
                            Icons.bloodtype,
                            () => _showInputDialog(context, "Hemoglobina"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildCompactDataCard(
                            hematocrito == null ? "---" : "$hematocrito%",
                            "Hematocrito",
                            Icons.pie_chart,
                            () => _showInputDialog(context, "Hematocrito"),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Container()), // Espacio vacío
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Separador para presión arterial
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
                            Icon(Icons.monitor_heart,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Presión Arterial • Sistólica y diastólica',
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
                      const SizedBox(height: 16),

                      // 5. PRESIÓN ARTERIAL
                      Row(
                        children: [
                          _buildCompactDataCard(
                            presionSistolica == null
                                ? "---"
                                : "$presionSistolica mmHg",
                            "Presión Sistólica",
                            Icons.trending_up,
                            () =>
                                _showInputDialog(context, "Presión Sistólica"),
                          ),
                          const SizedBox(width: 8),
                          _buildCompactDataCard(
                            presionDiastolica == null
                                ? "---"
                                : "$presionDiastolica mmHg",
                            "Presión Diastólica",
                            Icons.trending_down,
                            () =>
                                _showInputDialog(context, "Presión Diastólica"),
                          ),
                        ],
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
                                  await _finalizarAnalisis();
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
                                'Finalizar Análisis',
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
            "Ingrese $type",
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
                  hintText: _getHintText(type),
                  suffixText: _getUnitText(type),
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
              if (type == "Peso" || type == "Altura")
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Los valores calculados se actualizarán automáticamente",
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
                    _updateValueFromInput(type, value);
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
                    // Calcular valores automáticamente cuando sea relevante
                    if (type == "Peso" || type == "Altura") {
                      _calcularTodosLosValores();
                    } else if (type == "Triglicéridos") {
                      _calcularVLDL();
                      _calcularLDL();
                    } else if (type == "HDL" || type == "Colesterol Total") {
                      _calcularLDL();
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

  String _getHintText(String type) {
    switch (type) {
      case "Peso":
        return "Ej: 70";
      case "Altura":
        return "Ej: 170";
      case "Triglicéridos":
        return "Ej: 150";
      case "HDL":
        return "Ej: 50";
      case "Colesterol Total":
        return "Ej: 200";
      case "Glucosa":
        return "Ej: 100";
      case "Hemoglobina":
        return "Ej: 14.0";
      case "Hematocrito":
        return "Ej: 42";
      case "Presión Sistólica":
        return "Ej: 120";
      case "Presión Diastólica":
        return "Ej: 80";
      default:
        return "Ingrese valor";
    }
  }

  String _getUnitText(String type) {
    switch (type) {
      case "Peso":
        return "kg";
      case "Altura":
        return "cm";
      case "Triglicéridos":
      case "HDL":
      case "Colesterol Total":
      case "Glucosa":
        return "mg/dL";
      case "Hemoglobina":
        return "g/dL";
      case "Hematocrito":
        return "%";
      case "Presión Sistólica":
      case "Presión Diastólica":
        return "mmHg";
      default:
        return "";
    }
  }

  void _updateValueFromInput(String type, double value) {
    switch (type) {
      case "Peso":
        peso = value;
        break;
      case "Altura":
        altura = value;
        break;
      case "Triglicéridos":
        trigliceridos = value;
        break;
      case "HDL":
        hdl = value;
        break;
      case "Colesterol Total":
        colesterolTotal = value;
        break;
      case "Glucosa":
        glucosa = value;
        break;
      case "Hemoglobina":
        hemoglobina = value;
        break;
      case "Hematocrito":
        hematocrito = value;
        break;
      case "Presión Sistólica":
        presionSistolica = value;
        break;
      case "Presión Diastólica":
        presionDiastolica = value;
        break;
    }
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
}
