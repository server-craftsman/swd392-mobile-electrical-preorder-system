import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';
import 'package:mobile_electrical_preorder_system/layouts/admin_layout.dart';
import 'package:mobile_electrical_preorder_system/layouts/manager_layout.dart';

GoRoute protectedGuardRoute(String path, Widget child) {
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
            print(accessToken);
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
                    return AdminLayout();
                  } else if (role == 'ROLE_MANAGER') {
                    return ManagerLayout();
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
