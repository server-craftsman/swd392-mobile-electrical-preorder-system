import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/screens/animations/initial_animation_screen.dart';
import 'package:mobile_electrical_preorder_system/core/routing/run/app_router.dart';
import 'package:mobile_electrical_preorder_system/core/theme/app_theme.dart';

void main() {
  runApp(const InitialAnimationApp());
}

class InitialAnimationApp extends StatelessWidget {
  const InitialAnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InitialAnimationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Electrical Preorder System',
      routerDelegate: AppRouter.router.routerDelegate,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}
