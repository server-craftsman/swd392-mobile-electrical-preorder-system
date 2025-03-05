import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/layouts/main_layout.dart';
import 'package:mobile_electrical_preorder_system/features/first/index.dart';
import 'package:mobile_electrical_preorder_system/layouts/admin_layout.dart';
import 'package:mobile_electrical_preorder_system/layouts/staff_layout.dart';

// Main Guard Route
GoRoute mainGuardRoute(String path, Widget child) {
  return GoRoute(
    path: path,
    builder: (context, state) => MainLayout(child: child),
  );
}

GoRoute nullGuardRoute(String path, Widget child) {
  return GoRoute(path: path, builder: (context, state) => child);
}

GoRoute firstGuardRoute(String path, Widget child) {
  return GoRoute(path: path, builder: (context, state) => CustomWelcomePage());
}


