// lib/core/routing/public_routes.dart
import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/features/auth/login_page.dart';
import 'package:mobile_electrical_preorder_system/features/home/index.dart';
import 'package:mobile_electrical_preorder_system/features/profile/profile_page.dart';
import 'package:mobile_electrical_preorder_system/features/category/category_page.dart';
import 'package:mobile_electrical_preorder_system/features/settings/index.dart';
import 'run_guard.dart';
import 'package:mobile_electrical_preorder_system/features/first/index.dart';

List<GoRoute> publicRoutes = createPublicRoutes([
  {'path': '/home', 'page': HomePage()},
  {'path': '/profile', 'page': ProfilePage()},
  {'path': '/category', 'page': CategoryPage()},
  {'path': '/setting', 'page': SettingsDrawer()},
]);

List<GoRoute> firstRoutes = createFirstRoutes([
  {'path': '/', 'page': WelcomePage()},
]);

List<GoRoute> nullRoutes = createNullRoutes([
  {'path': '/login', 'page': LoginPage()},
]);
