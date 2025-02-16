import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/core/routing/public_routes/index.dart';
import 'package:mobile_electrical_preorder_system/core/routing/protected_routes/index.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    // initialLocation: '/',
    routes: [
      ...firstRoutes,
      ...nullRoutes,
      ...adminRoutes,
      ...publicRoutes,
      // ...protectedRoutes(),
    ],
  );
}
