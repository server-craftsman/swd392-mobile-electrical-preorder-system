// lib/core/routing/public_routes.dart
import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/features/auth/login_page.dart';
import 'package:mobile_electrical_preorder_system/features/home/index.dart';
import 'package:mobile_electrical_preorder_system/features/profile/profile_page.dart';
import 'package:mobile_electrical_preorder_system/features/category/category_page.dart';
import 'package:mobile_electrical_preorder_system/features/settings/index.dart';
import 'run_guard.dart';
import 'package:mobile_electrical_preorder_system/features/first/index.dart';
import 'package:mobile_electrical_preorder_system/features/auth/sign_up_page.dart';

//admin
// import 'package:mobile_electrical_preorder_system/features/admin/overview/index.dart';
// import 'package:mobile_electrical_preorder_system/features/admin/campaign/index.dart';
// import 'package:mobile_electrical_preorder_system/features/admin/user/index.dart';
// import 'package:mobile_electrical_preorder_system/features/admin/order/index.dart';

//manager
// import 'package:mobile_electrical_preorder_system/features/staff/overview/index.dart';
// import 'package:mobile_electrical_preorder_system/features/staff/statistic/index.dart';
// import 'package:mobile_electrical_preorder_system/features/staff/customer/index.dart';
// import 'package:mobile_electrical_preorder_system/features/staff/order/index.dart';

List<GoRoute> publicRoutes = createPublicRoutes([
  {'path': '/home', 'page': HomePage()},
  {'path': '/profile', 'page': ProfilePage()},
  {'path': '/category', 'page': CategoryPage()},
]);

List<GoRoute> firstRoutes = createFirstRoutes([
  {'path': '/', 'page': CustomWelcomePage()},
]);

List<GoRoute> nullRoutes = createNullRoutes([
  {'path': '/login', 'page': LoginPage()},
  {'path': '/signup', 'page': SignUpPage()},
  {'path': '/setting', 'page': SettingsDrawer()},
]);

// List<GoRoute> adminRoutes = createAdminRoutes([
//   {'path': '/admin/dashboard', 'page': DashboardPage()},
//   {'path': '/admin/campaigns', 'page': ManageCampaignPage()},
//   {'path': '/admin/users', 'page': CustomerManagePage()},
//   {'path': '/admin/orders', 'page': AdminOrdersPage()},
//   // {'path': '/admin/settings', 'page': AdminSettings()},
// ]);
