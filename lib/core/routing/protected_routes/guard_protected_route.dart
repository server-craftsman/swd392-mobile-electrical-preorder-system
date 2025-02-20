import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';
import 'package:mobile_electrical_preorder_system/layouts/admin_layout.dart';
import 'package:mobile_electrical_preorder_system/layouts/main_layout.dart';

GoRoute adminGuardRoute(String path, Widget child) {
  return GoRoute(
    path: path,
    builder: (context, state) {
      return FutureBuilder(
        future: TokenService.getAccessToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching token'));
          } else {
            final accessToken = snapshot.data;
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

                  if (role == 'ROLE_ADMIN') {
                    return AdminLayout(child: child);
                  } else if (role == 'ROLE_STAFF') {
                    return MainLayout(child: child);
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
