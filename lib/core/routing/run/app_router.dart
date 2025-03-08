import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/core/routing/unprotected_routes/index.dart';
import 'package:mobile_electrical_preorder_system/core/routing/protected_routes/index.dart';
import 'package:mobile_electrical_preorder_system/features/notification/index.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // Starting route
    navigatorKey:
        navigatorKey, // Add this for Firebase navigation compatibility
    routes: [
      // Notification route
      GoRoute(
        path:
            NotificationPage
                .route, // Use the static route from NotificationPage
        name: 'notification', // Optional: name for easier navigation
        builder: (context, state) {
          final message =
              state.extra
                  as RemoteMessage?; // Handle Firebase message if passed
          return NotificationPage(message: message);
        },
      ),
      //==========================================================================
      ...firstRoutes,
      ...nullRoutes,
      ...adminRoutes,
      ...staffRoutes,
    ],
  );
}
