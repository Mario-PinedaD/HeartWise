import 'package:heartwise/core/services/session_service.dart';

class SplashController {
  Future<bool> hasActiveSession() async {
    return await SessionService.isSessionActive();
  }
}
