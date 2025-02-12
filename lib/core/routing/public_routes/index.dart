// lib/core/routing/public_routes.dart
import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/features/home/home_page.dart';
import 'package:mobile_electrical_preorder_system/features/profile/profile_page.dart';
import 'package:mobile_electrical_preorder_system/features/category/category_page.dart';
import 'run_guard.dart';

List<GoRoute> publicRoutes = createPublicRoutes([
  {'path': '/', 'page': HomePage()},
  {'path': '/profile', 'page': ProfilePage()},
  {'path': '/category', 'page': CategoryPage()},
]);
