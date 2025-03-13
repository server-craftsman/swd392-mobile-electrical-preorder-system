import 'package:go_router/go_router.dart';
import 'guard_protected_route.dart';

List<GoRoute> createAdminProtectedRoutes(List<Map<String, dynamic>> routes) {
  return routes.map((route) {
    return protectedGuardAdminRoute(route['path'], route['page']);
  }).toList();
}

List<GoRoute> createStaffProtectedRoutes(List<Map<String, dynamic>> routes) {
  return routes.map((route) {
    return protectedGuardStaffRoute(route['path'], route['page']);
  }).toList();
}
