import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Helper {
  static void navigateTo(BuildContext context, String route) {
    GoRouter.of(context).go(route);
  }

  static void navigateSmoothly(BuildContext context, String route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GoRouter.of(context).push(
        route,
        extra: {
          'transition': PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return GoRouter.of(context).routerDelegate.build(context);
            },
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return Stack(
                children: [
                  Opacity(
                    opacity: 0.5, // Set background opacity to semi-transparent
                    child: Container(
                      color: Colors.black, // Background color
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(), // Loading spinner
                  ),
                ],
              );
            },
            opaque: false, // Ensure the background is not set to opaque
          ),
        },
      );
    });
  }

  static void navigateToWithArgs(
    BuildContext context,
    String route, {
    required Map<String, dynamic> args,
  }) {
    GoRouter.of(context).push(route, extra: args);
  }

  static void navigateWithAnimation(BuildContext context, String route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return GoRouter.of(context).routerDelegate.build(context);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    });
  }
}
