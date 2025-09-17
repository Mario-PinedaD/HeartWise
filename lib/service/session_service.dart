import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keyUserRole = 'user_role';
  static const String _keyLoginTimestamp = 'login_timestamp';

  // Duración de la sesión en días (por defecto 30 días)
  static const int sessionDurationDays = 30;

  // Guardar datos de sesión al iniciar sesión
  static Future<void> saveSession({
    required String userId,
    required String email,
    required String userName,
    String? userRole,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final finalRole = userRole ?? 'publico';
    print('DEBUG - Guardando sesión con rol: $finalRole');

    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserName, userName);
    await prefs.setString(_keyUserRole, finalRole);
    await prefs.setInt(
        _keyLoginTimestamp, DateTime.now().millisecondsSinceEpoch);

    print('DEBUG - Sesión guardada exitosamente');
  }

  // Verificar si hay una sesión activa válida
  static Future<bool> isSessionActive() async {
    final prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

    if (!isLoggedIn) return false;

    // Verificar si la sesión no ha expirado
    int? loginTimestamp = prefs.getInt(_keyLoginTimestamp);
    if (loginTimestamp == null) return false;

    DateTime loginDate = DateTime.fromMillisecondsSinceEpoch(loginTimestamp);
    DateTime now = DateTime.now();
    int daysDifference = now.difference(loginDate).inDays;

    if (daysDifference > sessionDurationDays) {
      // Sesión expirada, limpiar datos
      await clearSession();
      return false;
    }

    return true;
  }

  // Obtener datos del usuario almacenados
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final userData = {
      'userId': prefs.getString(_keyUserId),
      'email': prefs.getString(_keyUserEmail),
      'userName': prefs.getString(_keyUserName),
      'userRole': prefs.getString(_keyUserRole),
    };

    print('DEBUG - Datos obtenidos de sesión: $userData');
    return userData;
  }

  // Actualizar timestamp de la sesión (para mantenerla activa)
  static Future<void> updateSessionTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        _keyLoginTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  // Limpiar sesión (cerrar sesión)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserRole);
    await prefs.remove(_keyLoginTimestamp);
  }

  // Verificar si el usuario actual coincide (para múltiples cuentas)
  static Future<bool> isCurrentUser(String email) async {
    final userData = await getUserData();
    return userData['email'] == email;
  }
}
