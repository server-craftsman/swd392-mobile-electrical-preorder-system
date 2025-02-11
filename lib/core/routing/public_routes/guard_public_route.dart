import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/layouts/main_layout.dart';

// Main Guard Route
GoRoute mainGuardRoute(String path, Widget child) {
  return GoRoute(
    path: path,
    builder: (context, state) => MainLayout(child: child),
  );
}


