import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/core/routing/protected_routes/run_guard.dart';
//admin
import 'package:mobile_electrical_preorder_system/features/admin/overview/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/campaign/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/user/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/order/index.dart';
import 'package:mobile_electrical_preorder_system/features/profile/profile_page.dart';

//staff
import 'package:mobile_electrical_preorder_system/features/staff/overview/index.dart';
import 'package:mobile_electrical_preorder_system/features/staff/statistic/index.dart';
import 'package:mobile_electrical_preorder_system/features/staff/customer/index.dart';
import 'package:mobile_electrical_preorder_system/features/staff/order/index.dart';

//admin routes
List<GoRoute> adminRoutes = createAdminProtectedRoutes([
  {'path': '/admin/dashboard', 'page': DashboardPage()},
  {'path': '/admin/campaigns', 'page': ManageCampaignPage()},
  {'path': '/admin/users', 'page': CustomerManagePage()},
  {'path': '/admin/orders', 'page': AdminOrdersPage()},
  {'path': '/admin/profile', 'page': ProfilePage()},
  // {'path': '/admin/settings', 'page': AdminSettings()},
]);

//manager routes
List<GoRoute> staffRoutes = createStaffProtectedRoutes([
  {'path': '/staff/overview', 'page': OverviewPage()},
  {'path': '/staff/statistic', 'page': StatisticPage()},
  {'path': '/staff/customer', 'page': CustomerManagerPage()},
  {'path': '/staff/orders', 'page': ManagerOrdersPage()},
]);
