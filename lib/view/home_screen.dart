// Desactivación de advertencias específicas para mantener el código limpio
// ignore_for_file: use_key_in_widget_constructors, implementation_imports, prefer_const_constructors_in_immutables, unused_import, deprecated_member_use

// Importaciones necesarias para el funcionamiento
import 'package:flutter/material.dart'; // Widgets base de Flutter
import 'package:google_fonts/google_fonts.dart'; // Fuentes de Google
import 'package:heartwise/view/analisis_clinico.dart'; // Pantalla de análisis clínico
import 'package:heartwise/view/evaluacion_corporal.dart'; // Pantalla de evaluación corporal
import 'package:heartwise/view/resultados_cuenta.dart'; // Pantalla de resultados por correo
import 'package:heartwise/core/services/session_service.dart'; // Servicio de sesiones
import 'package:heartwise/view/login_screen.dart'; // Pantalla de login
import 'package:heartwise/service/database_service.dart'; // Servicio de base de datos

// Clase principal que representa la pantalla de inicio
// ignore: camel_case_types
class home_screen extends StatefulWidget {
  // Propiedades de la clase
  final Map<String, dynamic>? userInfo; // Información del usuario

  // Constructor de la clase
  home_screen({super.key, this.userInfo});

  @override
  State<home_screen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<home_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreenContent(userInfo: widget.userInfo),
    );
  }
}

// Widget de contenido para usar dentro de la navegación
class HomeScreenContent extends StatelessWidget {
  final Map<String, dynamic>? userInfo;

  const HomeScreenContent({super.key, this.userInfo});

  @override
  Widget build(BuildContext context) {
    return _HomeContentWidget(userInfo: userInfo);
  }
}

class _HomeContentWidget extends StatefulWidget {
  final Map<String, dynamic>? userInfo;

  const _HomeContentWidget({this.userInfo});

  @override
  State<_HomeContentWidget> createState() => _HomeContentWidgetState();
}

class _HomeContentWidgetState extends State<_HomeContentWidget> {
  Map<String, dynamic>? _userInfoMap;

  @override
  void initState() {
    super.initState();
    // Cargar datos del usuario desde el widget padre
    _loadUserDataFromParent();
  }

  void _loadUserDataFromParent() {
    setState(() {
      _userInfoMap = widget.userInfo;
    });
  }

  Future<void> _logout() async {
    // Mostrar modal de confirmación
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            '¿Cerrar sesión?',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFDC3644),
            ),
          ),
          content: Text(
            '¿Estás seguro de que deseas cerrar tu sesión?',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC3644),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Sí, salir',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    // Si el usuario confirmó, proceder con el logout
    if (shouldLogout == true) {
      // Limpiar la sesión
      await SessionService.clearSession();

      // Navegar a la pantalla de login y limpiar toda la pila
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  String _extractFirstNameAndLastName(String fullName) {
    List<String> nameParts = fullName.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0]} ${nameParts[1]}';
    }
    return nameParts.isNotEmpty ? nameParts[0] : 'Usuario';
  }

  @override
  Widget build(BuildContext context) {
    // Si no hay datos de usuario, mostrar placeholder
    if (_userInfoMap == null) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDC3644),
              Color(0xFFB71C1C),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Cargando datos del usuario...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _buildHomeContent(context);
  }

  Widget _buildHomeContent(BuildContext context) {
    // Usar los datos cargados
    Map<String, dynamic> userInfoMap = _userInfoMap!;

    // Obtención del rol del usuario (por defecto 'publico')
    String rol = userInfoMap['rol'] ?? 'publico';
    print('DEBUG - Rol final utilizado en home_screen: $rol');

    // Lista de pruebas disponibles con sus características
    final List<Map<String, dynamic>> datos = [
      {
        'titulo': 'Evaluación Corporal Básica',
        'descripcion':
            'Evalúa tus parámetros físicos clave, como peso, IMC y composición corporal para un control básico de tu salud.',
        'icono': Icons.fitness_center,
        'color': const Color(0xFF4CAF50), // Cambiado a verde
        'disponible': true, // Siempre disponible
        'direc': EvaluacionCorporalScreen(
          userData: userInfoMap,
          tipoAnalisis: 'AnalisisClinicosv1',
        )
      },
      {
        'titulo': 'Análisis Clínico Integral',
        'descripcion':
            'Análisis completo con laboratorios, perfil lipídico y evaluación cardiovascular integral.',
        'icono': Icons.biotech,
        'color': const Color(0xFF2196F3),
        'disponible': rol == 'medico' ? true : false, // Solo para médicos
        'direc': AnalisisClinicoScreen(
          userData: userInfoMap,
          tipoAnalisis: 'AnalisisCrlinicosv2',
        )
      },
    ];

    // Construcción del contenido
    return Container(
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
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header con información del usuario
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFDC3644),
                        const Color(0xFFDC3644).withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDC3644).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo blanco
                      Image.asset(
                        'lib/sources/logo-white.png',
                        height: 40,
                        width: 40,
                      ),

                      const SizedBox(width: 12),

                      // Información del usuario
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nombre y apellido
                            Text(
                              _extractFirstNameAndLastName(
                                  userInfoMap['nombre'] ?? 'Usuario'),
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            // Texto de bienvenida (segunda línea)
                            Text(
                              'Bienvenido de vuelta!',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Botón de salir
                      IconButton(
                        onPressed: _logout,
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 24,
                        ),
                        tooltip: 'Salir',
                      ),
                    ],
                  ),
                ),
              ),

              // Título de sección
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC3644),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Evaluaciones Médicas',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Grid de pruebas médicas
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = datos[index];
                      return _buildModernTestCard(
                        context: context,
                        titulo: item['titulo'],
                        descripcion: item['descripcion'],
                        icono: item['icono'],
                        color: item['color'],
                        disponible: item['disponible'],
                        direc: item['direc'],
                      );
                    },
                    childCount: datos.length,
                  ),
                ),
              ),

              // Espacio final
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget moderno para las cards de pruebas médicas
  Widget _buildModernTestCard({
    required BuildContext context,
    required String titulo,
    required String descripcion,
    required IconData icono,
    required Color color,
    required bool disponible,
    required Widget direc,
  }) {
    return GestureDetector(
      onTap: disponible
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => direc),
              );
            }
          : null,
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con ícono y disponibilidad
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: disponible
                      ? [
                          color,
                          color.withOpacity(0.8),
                        ]
                      : [
                          Colors.grey.shade300,
                          Colors.grey.shade400,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    top: -10,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(
                      icono,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  if (!disponible)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color:
                            disponible ? Colors.black87 : Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    Expanded(
                      child: Text(
                        descripcion,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: disponible
                              ? Colors.grey.shade600
                              : Colors.grey.shade500,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Estado
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: disponible
                            ? color.withOpacity(0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        disponible ? 'DISPONIBLE' : 'SOLO MÉDICOS',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: disponible ? color : Colors.grey.shade600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

// Placeholder para PerfilGeneticoScreen (debe ser implementado)
class PerfilGeneticoScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final String? tipoAnalisis;

  const PerfilGeneticoScreen({
    Key? key,
    this.userData,
    this.tipoAnalisis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Genético'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: const Center(
        child: Text('Funcionalidad en desarrollo'),
      ),
    );
  }
}
