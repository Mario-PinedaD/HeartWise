// Desactivación de advertencias específicas para mantener el código limpio
// ignore_for_file: use_key_in_widget_constructors, implementation_imports, prefer_const_constructors_in_immutables, unused_import, deprecated_member_use

// Importaciones necesarias para el funcionamiento
import 'package:flutter/material.dart'; // Widgets base de Flutter
import 'package:google_fonts/google_fonts.dart'; // Fuentes de Google
import 'package:heartwise/view/biomarcadores_screen.dart'; // Pantalla de biomarcadores
import 'package:heartwise/service/session_service.dart'; // Servicio de sesiones
import 'package:heartwise/view/login_screen.dart'; // Pantalla de login

// Clase principal que representa la pantalla de perfil
class PerfilScreen extends StatefulWidget {
  final Map<String, dynamic>? userInfo; // Información del usuario

  const PerfilScreen({super.key, this.userInfo});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Map<String, dynamic>? _userInfoMap;

  @override
  void initState() {
    super.initState();
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

    return _buildPerfilContent(context);
  }

  Widget _buildPerfilContent(BuildContext context) {
    // Usar los datos cargados
    Map<String, dynamic> userInfoMap = _userInfoMap!;

    // Obtención del rol del usuario (por defecto 'publico')
    String rol = userInfoMap['rol'] ?? 'publico';
    String email = userInfoMap['correo'] ?? userInfoMap['email'] ?? '';
    String nombre = userInfoMap['nombre'] ?? 'Usuario';

    // Lista de opciones del perfil
    final List<Map<String, dynamic>> opcionesPerfil = [
      {
        'titulo': 'Datos Personales',
        'descripcion': 'Edita tu información personal y de contacto',
        'icono': Icons.person,
        'color': const Color(0xFF4CAF50),
        'onTap': () => _showDatosPersonales(context),
      },
      {
        'titulo': 'Biomarcadores',
        'descripcion':
            'Gestiona tus biomarcadores para evaluaciones más precisas',
        'icono': Icons.biotech,
        'color': const Color(0xFF2196F3),
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BiomarcadoresScreen(userInfo: userInfoMap),
              ),
            ),
      },
      {
        'titulo': 'Historial Médico',
        'descripcion': 'Revisa tu historial de evaluaciones y resultados',
        'icono': Icons.history,
        'color': const Color(0xFFFF9800),
        'onTap': () => _showHistorialMedico(context),
      },
      {
        'titulo': 'Configuración',
        'descripcion': 'Preferencias de la aplicación y notificaciones',
        'icono': Icons.settings,
        'color': const Color(0xFF9C27B0),
        'onTap': () => _showConfiguracion(context),
      },
      {
        'titulo': 'Ayuda y Soporte',
        'descripcion': 'Obtén ayuda o contacta con nuestro equipo de soporte',
        'icono': Icons.help_outline,
        'color': const Color(0xFF607D8B),
        'onTap': () => _showAyuda(context),
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
                      // Avatar del usuario
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Información del usuario
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nombre y apellido
                            Text(
                              _extractFirstNameAndLastName(nombre),
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            // Email
                            Text(
                              email.isNotEmpty ? email : 'Email no disponible',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.95),
                              ),
                            ),

                            // Rol
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                rol.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
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
                        'Mi Perfil',
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

              // Lista de opciones del perfil
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final opcion = opcionesPerfil[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: _buildPerfilOption(
                          context: context,
                          titulo: opcion['titulo'],
                          descripcion: opcion['descripcion'],
                          icono: opcion['icono'],
                          color: opcion['color'],
                          onTap: opcion['onTap'],
                        ),
                      );
                    },
                    childCount: opcionesPerfil.length,
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

  // Widget para las opciones del perfil
  Widget _buildPerfilOption({
    required BuildContext context,
    required String titulo,
    required String descripcion,
    required IconData icono,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            // Ícono
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color,
                    color.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icono,
                color: Colors.white,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Flecha
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // Métodos para mostrar las diferentes pantallas/diálogos
  void _showDatosPersonales(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Datos Personales',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: const Text('Funcionalidad en desarrollo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showHistorialMedico(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Historial Médico',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: const Text('Funcionalidad en desarrollo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showConfiguracion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Configuración',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: const Text('Funcionalidad en desarrollo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showAyuda(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Ayuda y Soporte',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: const Text('Funcionalidad en desarrollo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

// CustomPainter para crear un patrón de fondo sutil (reutilizado del HomeScreen)
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
