import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/auth_guard.dart';
import 'package:mobile_electrical_preorder_system/features/dashboard/dashboard_page.dart';
import 'package:mobile_electrical_preorder_system/layouts/admin_layout.dart';
import 'package:mobile_electrical_preorder_system/layouts/main_layout.dart';

List<GoRoute> protectedRoutes() {
  return [
    GoRoute(
      path: '/admin',
      builder: (context, state) {
        return FutureBuilder<bool>(
          future: AuthGuard.checkAuth(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final isAdmin = snapshot.data == true;
              return isAdmin
                  ? AdminLayout(child: const DashBoard())
                  : MainLayout(child: const DashBoard());
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    ),
  ];
}
