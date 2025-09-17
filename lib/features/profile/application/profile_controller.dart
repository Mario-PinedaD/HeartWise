import 'package:heartwise/core/services/session_service.dart';

class ProfileController {
  Future<void> logout() async {
    await SessionService.clearSession();
  }
}
