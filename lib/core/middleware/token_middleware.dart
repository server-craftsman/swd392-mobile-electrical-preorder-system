import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TokenService {
  static Future<void> saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    print('Token saved: ${accessToken.substring(0, min(10, accessToken.length))}...');
  }

  static Future<Map<String, dynamic>?> decodeAccessToken(
    String? accessToken,
  ) async {
    if (accessToken == null || accessToken.isEmpty) {
      print('Decode attempt with null or empty token');
      return null;
    }

    try {
      final parts = accessToken.split('.');
      if (parts.length != 3) {
        print('Invalid access token format');
        return null;
      }

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final decodedJson = json.decode(decoded) as Map<String, dynamic>;
      print('Token decoded successfully, role: ${decodedJson['role']}');
      return decodedJson;
    } catch (e) {
      print('Error decoding access token: $e');
      return null;
    }
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token != null) {
      print('Token retrieved from storage: ${token.substring(0, min(10, token.length))}...');
    } else {
      print('No token found in storage');
    }
    return token;
  }
  
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAccessToken();
    if (token != null && token.isNotEmpty) {
      return {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
    } else {
      print('Warning: No access token found for API request');
      return {
        'Content-Type': 'application/json',
      };
    }
  }
}

// Helper function for string manipulation
int min(int a, int b) => a < b ? a : b;
