import 'package:go_router/go_router.dart';
import 'guard_unprotected_route.dart';

// run public routes - with main layout
List<GoRoute> createPublicRoutes(List<Map<String, dynamic>> routes) {
  return routes.map((route) {
    return mainGuardRoute(route['path'], route['page']);
  }).toList();
}

List<GoRoute> createFirstRoutes(List<Map<String, dynamic>> routes) {
  return routes.map((route) {
    return firstGuardRoute(route['path'], route['page']);
  }).toList();
}

List<GoRoute> createNullRoutes(List<Map<String, dynamic>> routes) {
  return routes.map((route) {
    return nullGuardRoute(route['path'], route['page']);
  }).toList();
}
