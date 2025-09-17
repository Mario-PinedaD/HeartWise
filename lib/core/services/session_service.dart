import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keyUserRole = 'user_role';
  static const String _keyLoginTimestamp = 'login_timestamp';

  static const int sessionDurationDays = 30;

  static Future<void> saveSession({
    required String userId,
    required String email,
    required String userName,
    String? userRole,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final finalRole = userRole ?? 'publico';
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserName, userName);
    await prefs.setString(_keyUserRole, finalRole);
    await prefs.setInt(
        _keyLoginTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<bool> isSessionActive() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return false;

    int? loginTimestamp = prefs.getInt(_keyLoginTimestamp);
    if (loginTimestamp == null) return false;

    DateTime loginDate = DateTime.fromMillisecondsSinceEpoch(loginTimestamp);
    DateTime now = DateTime.now();
    int daysDifference = now.difference(loginDate).inDays;

    if (daysDifference > sessionDurationDays) {
      await clearSession();
      return false;
    }

    return true;
  }

  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString(_keyUserId),
      'email': prefs.getString(_keyUserEmail),
      'userName': prefs.getString(_keyUserName),
      'userRole': prefs.getString(_keyUserRole),
    };
  }

  static Future<void> updateSessionTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        _keyLoginTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserRole);
    await prefs.remove(_keyLoginTimestamp);
  }

  static Future<bool> isCurrentUser(String email) async {
    final userData = await getUserData();
    return userData['email'] == email;
  }
}
