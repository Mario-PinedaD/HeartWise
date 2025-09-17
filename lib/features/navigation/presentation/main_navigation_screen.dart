// Desactivación de advertencias específicas para mantener el código limpio
// ignore_for_file: use_key_in_widget_constructors, implementation_imports, prefer_const_constructors_in_immutables, unused_import, deprecated_member_use

// Importaciones necesarias para el funcionamiento
import 'package:flutter/material.dart'; // Widgets base de Flutter
import 'package:google_fonts/google_fonts.dart'; // Fuentes de Google
import 'package:heartwise/features/home/presentation/home_screen.dart'; // Home screen
import 'package:heartwise/features/profile/presentation/perfil_screen.dart'; // Profile screen
import 'package:heartwise/core/services/session_service.dart'; // Session service
import 'package:heartwise/features/auth/presentation/login_screen.dart'; // Login screen

// Clase principal para la navegación con BottomNavigationBar
class MainNavigationScreen extends StatefulWidget {
  final Map<String, dynamic>? userInfo; // Información del usuario

  const MainNavigationScreen({super.key, this.userInfo});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0; // Índice de la pestaña actual
  int _previousIndex = 0; // Índice anterior para determinar dirección
  Map<String, dynamic>? _userInfoMap;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Actualizar el timestamp de la sesión al cargar la pantalla
    _updateSessionTimestamp();
    // Cargar datos del usuario
    _loadUserData();
  }

  Future<void> _updateSessionTimestamp() async {
    try {
      await SessionService.updateSessionTimestamp();
    } catch (e) {
      // Error silencioso - no afecta la funcionalidad
    }
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Si ya tenemos datos del widget, usarlos
      if (widget.userInfo != null) {
        Map<String, dynamic> userInfoMap = {};
        widget.userInfo?.forEach((key, value) {
          userInfoMap[key] = value;
        });
        setState(() {
          _userInfoMap = userInfoMap;
          _isLoading = false;
        });
        return;
      }

      // Si no tenemos datos, obtenerlos de la sesión
      final sessionData = await SessionService.getUserData();
      final userEmail = sessionData['email'];

      if (userEmail != null && userEmail.isNotEmpty) {
        String userRole = sessionData['userRole'] ?? 'publico';
        print('DEBUG - Rol cargado de sesión: $userRole');

        Map<String, dynamic> fallbackData = {
          'email': sessionData['email'] ?? '',
          'nombre': sessionData['userName'] ?? 'Usuario',
          'id': sessionData['userId'] ?? '',
          'rol': userRole,
        };

        setState(() {
          _userInfoMap = fallbackData;
          _isLoading = false;
        });
      } else {
        // Si no hay datos de sesión, redirigir al login
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print('Error cargando datos del usuario: $e');
      // En caso de error, usar datos mínimos
      final sessionData = await SessionService.getUserData();
      setState(() {
        _userInfoMap = {
          'email': sessionData['email'] ?? '',
          'nombre': sessionData['userName'] ?? 'Usuario',
          'id': sessionData['userId'] ?? '',
          'rol': sessionData['userRole'] ?? 'publico',
        };
        _isLoading = false;
      });
    }
  }

  // Lista de pantallas sin padding - el navegador flota por encima
  List<Widget> get _pages => [
        HomeScreenContent(userInfo: _userInfoMap),
        PerfilScreen(userInfo: _userInfoMap),
      ];

  @override
  Widget build(BuildContext context) {
    // Mostrar indicador de carga mientras se obtienen los datos
    if (_isLoading || _userInfoMap == null) {
      return Scaffold(
        body: Container(
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
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Contenido principal con transición lateral suave
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              // Determinar dirección: si vamos a la derecha (índice mayor) o izquierda (índice menor)
              final isGoingRight = _currentIndex > _previousIndex;

              return ClipRect(
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(isGoingRight ? 1.0 : -1.0, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey<int>(_currentIndex),
              child: _pages[_currentIndex],
            ),
          ),

          // Navegador flotante
          Positioned(
            bottom: 20,
            left: 120,
            right: 120,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.95),
                    Colors.white.withOpacity(0.90),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFDC3644).withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Inicio',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Perfil',
                    index: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _previousIndex = _currentIndex;
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 42,
        height: 42,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    const Color(0xFFDC3644),
                    const Color(0xFFDC3644).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFFDC3644).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(
            isActive ? activeIcon : icon,
            color: isActive ? Colors.white : Colors.grey.shade600,
            size: 22,
          ),
        ),
      ),
    );
  }
}
