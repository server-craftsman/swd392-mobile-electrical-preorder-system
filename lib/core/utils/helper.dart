import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Helper {
  static void navigateTo(BuildContext context, String route) {
    GoRouter.of(context).go(route);
  }

  static void navigateToWithArgs(BuildContext context, String route,
      {required Map<String, dynamic> args}) {
    GoRouter.of(context).push(route, extra: args);
  }
}
