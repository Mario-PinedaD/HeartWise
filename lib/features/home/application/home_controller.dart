import 'package:heartwise/core/services/session_service.dart';

class HomeController {
  Future<void> logout() async {
    await SessionService.clearSession();
  }
}
