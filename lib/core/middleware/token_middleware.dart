import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TokenService {
  static Future<void> saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
  }

  static Future<Map<String, dynamic>?> decodeAccessToken(
    String accessToken,
  ) async {
    try {
      final parts = accessToken.split('.');
      if (parts.length != 3) {
        print('Invalid access token');
        return null;
      }

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return json.decode(decoded) as Map<String, dynamic>;
    } catch (e) {
      print('Error decoding access token: $e');
      return null;
    }
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}
