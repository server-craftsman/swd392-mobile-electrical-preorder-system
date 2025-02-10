import 'package:mobile_electrical_preorder_system/features/dashboard/dashboard_page.dart';
import 'package:mobile_electrical_preorder_system/layouts/admin_layout.dart';
import 'package:mobile_electrical_preorder_system/layouts/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth_guard.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/dashboard',
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
              return const CircularProgressIndicator();
            },
          );
        },
      ),
    ],
  );
}
