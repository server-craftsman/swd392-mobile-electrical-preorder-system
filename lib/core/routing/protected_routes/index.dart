import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/core/routing/protected_routes/run_guard.dart';
//admin
import 'package:mobile_electrical_preorder_system/features/admin/overview/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/campaign/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/user/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/order/index.dart';
import 'package:mobile_electrical_preorder_system/features/profile/profile_page.dart';

//manager
import 'package:mobile_electrical_preorder_system/features/manager/overview/index.dart';
import 'package:mobile_electrical_preorder_system/features/manager/statistic/index.dart';
import 'package:mobile_electrical_preorder_system/features/manager/customer/index.dart';
import 'package:mobile_electrical_preorder_system/features/manager/order/index.dart';

//admin routes
List<GoRoute> adminRoutes = createProtectedRoutes([
  {'path': '/admin/dashboard', 'page': DashboardPage()},
  {'path': '/admin/campaigns', 'page': ManageCampaignPage()},
  {'path': '/admin/users', 'page': CustomerManagePage()},
  {'path': '/admin/orders', 'page': AdminOrdersPage()},
  {'path': '/admin/profile', 'page': ProfilePage()},
  // {'path': '/admin/settings', 'page': AdminSettings()},
]);

//manager routes
List<GoRoute> managerRoutes = createProtectedRoutes([
  {'path': '/manager/overview', 'page': OverviewPage()},
  {'path': '/manager/statistic', 'page': StatisticPage()},
  {'path': '/manager/customer', 'page': CustomerManagerPage()},
  {'path': '/manager/orders', 'page': ManagerOrdersPage()},
]);
