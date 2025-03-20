import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';
import 'package:mobile_electrical_preorder_system/layouts/admin_layout.dart';
import 'package:mobile_electrical_preorder_system/layouts/staff_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoRoute protectedGuardAdminRoute(String path, Widget child) {
  return GoRoute(
    path: path,
    builder: (context, state) {
      return FutureBuilder(
        future: TokenService.getAccessToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Error fetching token: ${snapshot.error}");
            return Center(child: Text('Error fetching token'));
          } else {
            final accessToken = snapshot.data;
            print(
              "Protected route token check: ${accessToken != null ? 'Token exists' : 'No token'}",
            );
            return FutureBuilder(
              future: TokenService.decodeAccessToken(accessToken ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error decoding token'));
                } else {
                  final decodedToken = snapshot.data;
                  final role = decodedToken?['role'];

                  // Save user ID in shared preferences if not already saved
                  if (decodedToken != null && decodedToken.containsKey('id')) {
                    _saveUserIdToPrefs(decodedToken['id'].toString());
                  }

                  // Check if role is either ADMIN or STAFF
                  if (role == 'ROLE_ADMIN') {
                    // Return the layout based on role with the child widget
                    if (role == 'ROLE_ADMIN') {
                      return AdminLayout();
                    }

                    return Center(child: Text('Access Denied'));
                  } else {
                    return Center(child: Text('Access Denied'));
                  }
                }
              },
            );
          }
        },
      );
    },
  );
}

GoRoute protectedGuardStaffRoute(String path, Widget child) {
  return GoRoute(
    path: path,
    builder: (context, state) {
      return FutureBuilder(
        future: TokenService.getAccessToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Error fetching token: ${snapshot.error}");
            return Center(child: Text('Error fetching token'));
          } else {
            final accessToken = snapshot.data;
            print(
              "Protected route token check: ${accessToken != null ? 'Token exists' : 'No token'}",
            );
            return FutureBuilder(
              future: TokenService.decodeAccessToken(accessToken ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error decoding token'));
                } else {
                  final decodedToken = snapshot.data;
                  final role = decodedToken?['role'];

                  // Save user ID in shared preferences if not already saved
                  if (decodedToken != null && decodedToken.containsKey('id')) {
                    _saveUserIdToPrefs(decodedToken['id'].toString());
                  }

                  // Check if role is either ADMIN or STAFF
                  if (role == 'ROLE_STAFF') {
                    // Return the layout based on role with the child widget
                    if (role == 'ROLE_STAFF') {
                      return StaffLayout(child: child);
                    }
                    return Center(child: Text('Access Denied'));
                  } else {
                    return Center(child: Text('Access Denied'));
                  }
                }
              },
            );
          }
        },
      );
    },
  );
}

// Helper function to save user ID to shared preferences
Future<void> _saveUserIdToPrefs(String userId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final existingId = prefs.getString('userId');
    if (existingId != userId) {
      await prefs.setString('userId', userId);
      print('Updated user ID in prefs: $userId');
    }
  } catch (e) {
    print('Error saving user ID to prefs: $e');
  }
}
