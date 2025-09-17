import 'package:heartwise/service/database_service.dart';
import 'package:heartwise/core/services/session_service.dart';

class LoginController {
  Future<Map<String, dynamic>?> authenticate(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return null;
    }
    final result = await DatabaseService.enviarUsuario({'email': email, 'password': password});
    if (result != null && result['usuario'] != null) {
      final user = result['usuario'] as Map<String, dynamic>;
      final userRole = user['rol']?.toString() ?? 'publico';
      await SessionService.saveSession(
        userId: user['id']?.toString() ?? '',
        email: user['correo']?.toString() ?? email,
        userName: user['nombre']?.toString() ?? '',
        userRole: userRole,
      );
      return user;
    }
    return null;
  }
}
