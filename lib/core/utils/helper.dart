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

  static void navigateWithAnimation(BuildContext context, String route) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          GoRouter.of(context).routerDelegate.build(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ));
  }
}
