// Desactivación de advertencias específicas para mantener el código limpio
// ignore_for_file: use_key_in_widget_constructors, implementation_imports, prefer_const_constructors_in_immutables, unused_import, deprecated_member_use

// Importaciones necesarias para el funcionamiento
import 'package:flutter/material.dart'; // Widgets base de Flutter
import 'package:google_fonts/google_fonts.dart'; // Fuentes de Google
import 'package:flutter/services.dart'; // Para los input formatters

// Clase principal que representa la pantalla de biomarcadores
class BiomarcadoresScreen extends StatefulWidget {
  final Map<String, dynamic>? userInfo; // Información del usuario

  const BiomarcadoresScreen({super.key, this.userInfo});

  @override
  State<BiomarcadoresScreen> createState() => _BiomarcadoresScreenState();
}

class _BiomarcadoresScreenState extends State<BiomarcadoresScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final Map<String, TextEditingController> _controllers = {};

  // Lista de biomarcadores con sus características
  final List<Map<String, dynamic>> _biomarcadores = [
    {
      'id': 'peso',
      'titulo': 'Peso',
      'unidad': 'kg',
      'icono': Icons.monitor_weight,
      'color': const Color(0xFF4CAF50),
      'valor': '',
      'categoria': 'Antropométricos',
    },
    {
      'id': 'altura',
      'titulo': 'Altura',
      'unidad': 'cm',
      'icono': Icons.height,
      'color': const Color(0xFF4CAF50),
      'valor': '',
      'categoria': 'Antropométricos',
    },
    {
      'id': 'presion_sistolica',
      'titulo': 'Presión Sistólica',
      'unidad': 'mmHg',
      'icono': Icons.favorite,
      'color': const Color(0xFFE91E63),
      'valor': '',
      'categoria': 'Cardiovasculares',
    },
    {
      'id': 'presion_diastolica',
      'titulo': 'Presión Diastólica',
      'unidad': 'mmHg',
      'icono': Icons.favorite,
      'color': const Color(0xFFE91E63),
      'valor': '',
      'categoria': 'Cardiovasculares',
    },
    {
      'id': 'frecuencia_cardiaca',
      'titulo': 'Frecuencia Cardíaca',
      'unidad': 'bpm',
      'icono': Icons.monitor_heart,
      'color': const Color(0xFFE91E63),
      'valor': '',
      'categoria': 'Cardiovasculares',
    },
    {
      'id': 'glucosa',
      'titulo': 'Glucosa en Sangre',
      'unidad': 'mg/dL',
      'icono': Icons.bloodtype,
      'color': const Color(0xFF2196F3),
      'valor': '',
      'categoria': 'Laboratorio',
    },
    {
      'id': 'colesterol_total',
      'titulo': 'Colesterol Total',
      'unidad': 'mg/dL',
      'icono': Icons.bloodtype,
      'color': const Color(0xFF2196F3),
      'valor': '',
      'categoria': 'Laboratorio',
    },
    {
      'id': 'hdl',
      'titulo': 'HDL (Colesterol Bueno)',
      'unidad': 'mg/dL',
      'icono': Icons.bloodtype,
      'color': const Color(0xFF2196F3),
      'valor': '',
      'categoria': 'Laboratorio',
    },
    {
      'id': 'ldl',
      'titulo': 'LDL (Colesterol Malo)',
      'unidad': 'mg/dL',
      'icono': Icons.bloodtype,
      'color': const Color(0xFF2196F3),
      'valor': '',
      'categoria': 'Laboratorio',
    },
    {
      'id': 'trigliceridos',
      'titulo': 'Triglicéridos',
      'unidad': 'mg/dL',
      'icono': Icons.bloodtype,
      'color': const Color(0xFF2196F3),
      'valor': '',
      'categoria': 'Laboratorio',
    },
    {
      'id': 'temperatura',
      'titulo': 'Temperatura Corporal',
      'unidad': '°C',
      'icono': Icons.thermostat,
      'color': const Color(0xFFFF9800),
      'valor': '',
      'categoria': 'Vitales',
    },
    {
      'id': 'saturacion_oxigeno',
      'titulo': 'Saturación de Oxígeno',
      'unidad': '%',
      'icono': Icons.air,
      'color': const Color(0xFF9C27B0),
      'valor': '',
      'categoria': 'Vitales',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadSavedValues();
  }

  void _initializeControllers() {
    for (var biomarcador in _biomarcadores) {
      _controllers[biomarcador['id']] = TextEditingController();
    }
  }

  void _loadSavedValues() {
    // Aquí se cargarían los valores guardados desde SharedPreferences o base de datos
    // Por ahora usamos valores de ejemplo
    setState(() {
      // Valores de ejemplo
      _controllers['peso']?.text = '70.5';
      _controllers['altura']?.text = '175';
      _controllers['presion_sistolica']?.text = '120';
      _controllers['presion_diastolica']?.text = '80';
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Map<String, List<Map<String, dynamic>>> get _biomarcadoresPorCategoria {
    Map<String, List<Map<String, dynamic>>> categorias = {};

    for (var biomarcador in _biomarcadores) {
      String categoria = biomarcador['categoria'];
      if (!categorias.containsKey(categoria)) {
        categorias[categoria] = [];
      }
      categorias[categoria]!.add(biomarcador);
    }

    return categorias;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Biomarcadores',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFDC3644),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveValues,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade50,
              Colors.white,
              Colors.grey.shade100.withOpacity(0.3),
            ],
          ),
        ),
        child: CustomPaint(
          painter: BackgroundPatternPainter(),
          child: Form(
            key: _formKey,
            child: CustomScrollView(
              slivers: [
                // Header informativo
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFDC3644).withOpacity(0.1),
                          const Color(0xFFDC3644).withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFDC3644).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: const Color(0xFFDC3644),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Biomarcadores Personales',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFDC3644),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Mantén actualizados tus biomarcadores para obtener evaluaciones más precisas y personalizadas.',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Categorías de biomarcadores
                ..._biomarcadoresPorCategoria.entries.map((entry) {
                  return _buildCategoriaSection(entry.key, entry.value);
                }).toList(),

                // Espacio final
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriaSection(
      String categoria, List<Map<String, dynamic>> biomarcadores) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la categoría
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC3644),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    categoria,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Grid de biomarcadores de esta categoría
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: biomarcadores.length,
              itemBuilder: (context, index) {
                final biomarcador = biomarcadores[index];
                return _buildBiomarcadorCard(biomarcador);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiomarcadorCard(Map<String, dynamic> biomarcador) {
    final controller = _controllers[biomarcador['id']]!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con ícono
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: biomarcador['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    biomarcador['icono'],
                    color: biomarcador['color'],
                    size: 18,
                  ),
                ),
                const Spacer(),
                Text(
                  biomarcador['unidad'],
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Título
            Text(
              biomarcador['titulo'],
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Campo de entrada
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: biomarcador['color'],
                ),
                decoration: InputDecoration(
                  hintText: '0.0',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: biomarcador['color'],
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Campos opcionales
                  }
                  if (double.tryParse(value) == null) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveValues() {
    if (_formKey.currentState!.validate()) {
      // Aquí se guardarían los valores en SharedPreferences o base de datos

      Map<String, String> valoresGuardados = {};
      for (var entry in _controllers.entries) {
        if (entry.value.text.isNotEmpty) {
          valoresGuardados[entry.key] = entry.value.text;
        }
      }

      // Mostrar confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Biomarcadores guardados exitosamente',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      print('Valores guardados: $valoresGuardados');
    }
  }
}

// CustomPainter para crear un patrón de fondo sutil
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Crear un patrón de puntos sutiles
    const double spacing = 30.0;
    const double dotRadius = 1.5;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(
          Offset(x, y),
          dotRadius,
          Paint()
            ..color = Colors.grey.withOpacity(0.1)
            ..style = PaintingStyle.fill,
        );
      }
    }

    // Agregar algunas líneas diagonales muy sutiles
    final linePaint = Paint()
      ..color = Colors.grey.withOpacity(0.05)
      ..strokeWidth = 0.5;

    for (double i = -size.height; i < size.width + size.height; i += 80) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
