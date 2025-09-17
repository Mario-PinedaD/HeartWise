// ignore_for_file: library_private_types_in_public_api, unrelated_type_equality_checks, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'consultar_especialistas.dart';

/// Widget principal para mostrar los resultados de análisis médicos
class ResultadosScreen extends StatefulWidget {
  // Propiedades para recibir datos
  final String? dato1; // Valor numérico de homocisteína
  final String? dato2; // Nivel de riesgo (bajo, medio, alto)
  final String? dato3; // Tipo de análisis
  final String? correo; // Correo/nombre del paciente
  final Map<String, dynamic>? datosIngresados; // Datos antropométricos

  // Constructor con parámetros nombrados opcionales
  const ResultadosScreen(
      {super.key,
      this.dato1,
      this.dato2,
      this.dato3,
      this.correo,
      this.datosIngresados});

  @override
  _ResultadosScreenState createState() => _ResultadosScreenState();
}

/// Estado del widget que maneja la lógica
class _ResultadosScreenState extends State<ResultadosScreen> {
  // Método para determinar el texto según el nivel
  String _getNivelTexto() {
    final nivel = widget.dato2?.toLowerCase() ?? '';
    switch (nivel) {
      case 'bajo':
      case 'medio':
        return 'Normal';
      case 'alto':
        return 'Alto';
      default:
        return 'Normal';
    }
  }

  // Método para formatear valores numéricos con decimales controlados
  String _formatValue(dynamic value, int decimals) {
    if (value == null) return '---';

    // Si es string, verificar si está vacía o es "0"
    if (value is String) {
      if (value.trim().isEmpty || value == '0' || value == '00') return '---';
      final parsedValue = double.tryParse(value);
      if (parsedValue == null) return '---';
      if (parsedValue == 0) return '---';
      return parsedValue.toStringAsFixed(decimals);
    }

    // Si es número (int o double)
    if (value is num) {
      if (value == 0) return '---';
      return value.toStringAsFixed(decimals);
    }

    return '---';
  }

  @override
  Widget build(BuildContext context) {
    // Variable para almacenar la descripción del resultado
    String description = '';

    // Determina el mensaje basado en el nivel de homocisteína
    description =
        "Tu nivel de Homocisteína depende de la información introducida. De ser como resultado un valor alto, te recomendamos acudir a un médico para realizar pruebas más detalladas.";

    // Construcción de la interfaz de usuario
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
                const SizedBox(height: 16),

                // Título optimizado con mejor jerarquía
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RESULTADOS',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Card ultra-compacto de homocisteína - Técnica "Pill Badge"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10), // Pill shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Icono minimal
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDC3644),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Contenido compacto
                        Text(
                          "Homocisteína:",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Resultado destacado
                        Expanded(
                          child: Text(
                            _getNivelTexto(),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFDC3644),
                            ),
                          ),
                        ),

                        // Estado minimal
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "✓",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Información del paciente
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paciente',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${widget.correo ?? 'Usuario'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                (widget.datosIngresados?['Genero'] == 1)
                                    ? Icons.male
                                    : Icons.female,
                                color: Colors.white.withOpacity(0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                (widget.datosIngresados?['Genero'] == 1)
                                    ? 'Masculino'
                                    : 'Femenino',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Título de detalles con mejor jerarquía
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Detalles Biométricos",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Cards compactas con datos - Diseño actualizado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      // Primera fila: Datos básicos
                      Row(
                        children: [
                          _buildCompactDataCard(
                            "${_formatValue(widget.datosIngresados?['Peso'], 0)} kg",
                            "Peso",
                            Icons.monitor_weight,
                          ),
                          const SizedBox(width: 8),
                          _buildCompactDataCard(
                            "${_formatValue(widget.datosIngresados?['Talla'], 0)} cm",
                            "Talla",
                            Icons.height,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Segunda fila: IMC y Edad
                      Row(
                        children: [
                          _buildCompactDataCard(
                            _formatValue(widget.datosIngresados?['IMC'], 1),
                            "IMC",
                            Icons.assessment,
                          ),
                          const SizedBox(width: 8),
                          _buildCompactDataCard(
                            "${_formatValue(widget.datosIngresados?['Edad'], 0)} años",
                            "Edad",
                            Icons.calendar_today,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Tercera fila: Composición corporal
                      Row(
                        children: [
                          _buildCompactDataCard(
                            "${_formatValue(widget.datosIngresados?['GrasaT'], 1)}%",
                            "Grasa Total",
                            Icons.opacity,
                          ),
                          const SizedBox(width: 8),
                          _buildCompactDataCard(
                            "${_formatValue(widget.datosIngresados?['Musculo'], 1)}%",
                            "Masa Muscular",
                            Icons.fitness_center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Cuarta fila: Metabolismo y Grasa Visceral
                      Row(
                        children: [
                          _buildCompactDataCard(
                            "${_formatValue(widget.datosIngresados?['MetabBasal'], 0)} kcal",
                            "Metabolismo Basal",
                            Icons.local_fire_department,
                          ),
                          const SizedBox(width: 8),
                          _buildCompactDataCard(
                            _formatValue(
                                widget.datosIngresados?['GrasaVisc'], 1),
                            "Grasa Visceral",
                            Icons.opacity_outlined,
                          ),
                        ],
                      ),

                      // Si es análisis clínico, mostrar campos adicionales
                      if (widget.dato3 == "Análisis Clínico Integral" ||
                          widget.datosIngresados?['COL'] != null ||
                          widget.datosIngresados?['TRG'] != null ||
                          widget.datosIngresados?['HDL'] != null) ...[
                        const SizedBox(height: 12),

                        // Separador para análisis clínico
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.biotech,
                                  color: Colors.white, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                'Análisis Clínico',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Quinta fila: Perfil Lipídico
                        Row(
                          children: [
                            _buildCompactDataCard(
                              "${_formatValue(widget.datosIngresados?['COL'], 0)} mg/dL",
                              "Colesterol Total",
                              Icons.circle,
                            ),
                            const SizedBox(width: 8),
                            _buildCompactDataCard(
                              "${_formatValue(widget.datosIngresados?['TRG'], 0)} mg/dL",
                              "Triglicéridos",
                              Icons.water_drop,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Sexta fila: HDL y LDL
                        Row(
                          children: [
                            _buildCompactDataCard(
                              "${_formatValue(widget.datosIngresados?['HDL'], 0)} mg/dL",
                              "HDL",
                              Icons.favorite,
                            ),
                            const SizedBox(width: 8),
                            _buildCompactDataCard(
                              "${_formatValue(widget.datosIngresados?['LDL'], 0)} mg/dL",
                              "LDL",
                              Icons.coronavirus,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Séptima fila: VLDL y Glucosa
                        Row(
                          children: [
                            _buildCompactDataCard(
                              "${_formatValue(widget.datosIngresados?['VLDL'], 0)} mg/dL",
                              "VLDL",
                              Icons.bubble_chart,
                            ),
                            const SizedBox(width: 8),
                            _buildCompactDataCard(
                              "${_formatValue(widget.datosIngresados?['GLU'], 0)} mg/dL",
                              "Glucosa",
                              Icons.healing,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Octava fila: Hemoglobina y Hematocrito
                        Row(
                          children: [
                            _buildCompactDataCard(
                              "${_formatValue(widget.datosIngresados?['HGB'], 1)} g/dL",
                              "Hemoglobina",
                              Icons.bloodtype,
                            ),
                            const SizedBox(width: 8),
                            _buildCompactDataCard(
                              "${_formatValue(widget.datosIngresados?['HCT'], 1)}%",
                              "Hematocrito",
                              Icons.pie_chart,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Novena fila: Presión arterial
                        Row(
                          children: [
                            _buildCompactDataCard(
                              "${_formatValue(widget.datosIngresados?['SBP'], 0)} mmHg",
                              "Presión Sistólica",
                              Icons.trending_up,
                            ),
                            const SizedBox(width: 8),
                            _buildCompactDataCard(
                              "${_formatValue(widget.datosIngresados?['DBP'], 0)} mmHg",
                              "Presión Diastólica",
                              Icons.trending_down,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Sección de interpretación mejorada
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Interpretación',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Botón de doctores disponibles - Diseño mejorado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
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
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ConsultarEspecialistasScreen(
                                pacienteNombre: widget.correo,
                                tipoAnalisis: widget.dato3,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.medical_services_rounded,
                                color: const Color(0xFFDC3644),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Consultar Especialista",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFDC3644),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget para construir cards compactas de datos con mejores prácticas UI/UX
  Widget _buildCompactDataCard(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        height: 76, // Altura ligeramente optimizada
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // Radio más redondeado
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
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
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC3644).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFFDC3644),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
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
                  value == "null" || value.isEmpty || value.contains("null")
                      ? "00"
                      : value,
                  style: GoogleFonts.poppins(
                    fontSize:
                        15, // Tamaño ligeramente mayor para mejor legibilidad
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
