import 'package:shared_preferences/shared_preferences.dart';

class AuthGuard {
  static Future<bool> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null;
  }
}
