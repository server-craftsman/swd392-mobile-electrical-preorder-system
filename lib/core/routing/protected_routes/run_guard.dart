import 'package:go_router/go_router.dart';
import 'guard_protected_route.dart';

List<GoRoute> createProtectedRoutes(List<Map<String, dynamic>> routes) {
  return routes.map((route) {
    return protectedGuardRoute(route['path'], route['page']);
  }).toList();
}