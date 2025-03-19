import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';
import 'package:mobile_electrical_preorder_system/layouts/admin_layout.dart';
import 'package:mobile_electrical_preorder_system/layouts/staff_layout.dart';

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
            print("Protected route token check: ${accessToken != null ? 'Token exists' : 'No token'}");
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
            print("Protected route token check: ${accessToken != null ? 'Token exists' : 'No token'}");
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
