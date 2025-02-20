import 'package:go_router/go_router.dart';
import 'guard_protected_route.dart';

List<GoRoute> createAdminProtectedRoutes(List<Map<String, dynamic>> routes) {
  return routes.map((route) {
    return adminGuardRoute(route['path'], route['page']);
  }).toList();
}
