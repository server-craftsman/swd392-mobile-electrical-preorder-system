import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/core/routing/protected_routes/run_guard.dart';
//admin
import 'package:mobile_electrical_preorder_system/features/admin/overview/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/campaign/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/user/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/order/index.dart';

List<GoRoute> adminRoutes = createAdminProtectedRoutes([
  {'path': '/admin/dashboard', 'page': DashboardPage()},
  {'path': '/admin/campaigns', 'page': ManageCampaignPage()},
  {'path': '/admin/users', 'page': CustomerManagePage()},
  {'path': '/admin/orders', 'page': AdminOrdersPage()},
  // {'path': '/admin/settings', 'page': AdminSettings()},
]);
