// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget para la pantalla de consultar especialistas
class ConsultarEspecialistasScreen extends StatefulWidget {
  final String? pacienteNombre;
  final String? tipoAnalisis;

  const ConsultarEspecialistasScreen({
    super.key,
    this.pacienteNombre,
    this.tipoAnalisis,
  });

  @override
  _ConsultarEspecialistasScreenState createState() =>
      _ConsultarEspecialistasScreenState();
}

class _ConsultarEspecialistasScreenState
    extends State<ConsultarEspecialistasScreen> {
  int selectedEspecialista = -1;
  String selectedMotivo = '';

  // Lista de especialistas disponibles
  final List<Map<String, dynamic>> especialistas = [
    {
      'nombre': 'Dr. Carlos Mendoza',
      'especialidad': 'Cardiología',
      'experiencia': '15 años',
      'rating': 4.8,
      'disponibilidad': 'Disponible',
      'precio': '\$75',
      'icono': Icons.favorite,
      'color': Colors.red,
    },
    {
      'nombre': 'Dra. Ana García',
      'especialidad': 'Medicina Interna',
      'experiencia': '12 años',
      'rating': 4.9,
      'disponibilidad': 'Disponible',
      'precio': '\$65',
      'icono': Icons.medical_services,
      'color': Colors.blue,
    },
    {
      'nombre': 'Dr. Miguel Torres',
      'especialidad': 'Endocrinología',
      'experiencia': '10 años',
      'rating': 4.7,
      'disponibilidad': 'Ocupado',
      'precio': '\$80',
      'icono': Icons.science,
      'color': Colors.green,
    },
    {
      'nombre': 'Dra. Laura Vega',
      'especialidad': 'Nutrición Clínica',
      'experiencia': '8 años',
      'rating': 4.6,
      'disponibilidad': 'Disponible',
      'precio': '\$50',
      'icono': Icons.restaurant,
      'color': Colors.orange,
    },
  ];

  // Lista de motivos de consulta
  final List<String> motivosConsulta = [
    'Resultados anormales',
    'Segunda opinión',
    'Plan de tratamiento',
    'Consulta preventiva',
    'Seguimiento médico',
    'Otros'
  ];

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
                const SizedBox(height: 16),

                // Título
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ESPECIALISTAS',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Conecta con profesionales de la salud',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Card de información del paciente
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: const Color(0xFFDC3644),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Información de Consulta',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                            'Paciente', widget.pacienteNombre ?? 'Usuario'),
                        const SizedBox(height: 6),
                        _buildInfoRow('Tipo de Análisis',
                            widget.tipoAnalisis ?? 'Análisis General'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sección de motivo de consulta
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.assignment,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Motivo de Consulta',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Grid de motivos
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 3.5,
                        ),
                        itemCount: motivosConsulta.length,
                        itemBuilder: (context, index) {
                          final motivo = motivosConsulta[index];
                          final isSelected = selectedMotivo == motivo;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedMotivo = isSelected ? '' : motivo;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFDC3644)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFDC3644)
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  motivo,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Lista de especialistas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.medical_services,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Especialistas Disponibles',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Lista de especialistas
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: especialistas.length,
                        itemBuilder: (context, index) {
                          final especialista = especialistas[index];
                          final isSelected = selectedEspecialista == index;
                          final isDisponible =
                              especialista['disponibilidad'] == 'Disponible';

                          return GestureDetector(
                            onTap: isDisponible
                                ? () {
                                    setState(() {
                                      selectedEspecialista =
                                          isSelected ? -1 : index;
                                    });
                                  }
                                : null,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFDC3644)
                                      : Colors.grey.shade200,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Avatar del especialista
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? especialista['color']
                                              .withOpacity(0.1)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      especialista['icono'],
                                      color: isSelected
                                          ? especialista['color']
                                          : Colors.grey.shade600,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Información del especialista
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          especialista['nombre'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          especialista['especialidad'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${especialista['rating']}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              '${especialista['experiencia']}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Estado y precio
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDisponible
                                              ? Colors.green.withOpacity(0.2)
                                              : Colors.red.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          especialista['disponibilidad'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: isDisponible
                                                ? Colors.green.shade700
                                                : Colors.red.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        especialista['precio'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? const Color(0xFFDC3644)
                                              : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Botón de agendar cita
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: selectedEspecialista != -1 &&
                              selectedMotivo.isNotEmpty
                          ? LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.grey.shade50,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : null,
                      color:
                          selectedEspecialista == -1 || selectedMotivo.isEmpty
                              ? Colors.white.withOpacity(0.3)
                              : null,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedEspecialista != -1 &&
                                selectedMotivo.isNotEmpty
                            ? const Color(0xFFDC3644).withOpacity(0.3)
                            : Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: selectedEspecialista != -1 &&
                              selectedMotivo.isNotEmpty
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: selectedEspecialista != -1 &&
                                selectedMotivo.isNotEmpty
                            ? () {
                                _mostrarConfirmacionCita();
                              }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: selectedEspecialista != -1 &&
                                        selectedMotivo.isNotEmpty
                                    ? const Color(0xFFDC3644)
                                    : Colors.white.withOpacity(0.6),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Agendar Consulta",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: selectedEspecialista != -1 &&
                                          selectedMotivo.isNotEmpty
                                      ? const Color(0xFFDC3644)
                                      : Colors.white.withOpacity(0.6),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _mostrarConfirmacionCita() {
    final especialistaSeleccionado = especialistas[selectedEspecialista];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Confirmar Cita',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalles de la consulta:',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildConfirmacionRow(
                  'Especialista', especialistaSeleccionado['nombre']),
              _buildConfirmacionRow(
                  'Especialidad', especialistaSeleccionado['especialidad']),
              _buildConfirmacionRow('Motivo', selectedMotivo),
              _buildConfirmacionRow(
                  'Precio', especialistaSeleccionado['precio']),
              const SizedBox(height: 12),
              Text(
                'Se enviará un correo con los detalles de la cita programada.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _procesarCita();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC3644),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Confirmar',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfirmacionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _procesarCita() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Cita agendada exitosamente',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    // Aquí se integraría con el backend para agendar la cita
    // Por ahora, simulamos el proceso y regresamos a la pantalla anterior
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }
}
