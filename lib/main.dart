import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/screens/animations/initial_animation_screen.dart';
import 'package:mobile_electrical_preorder_system/core/routing/run/app_router.dart';
import 'package:mobile_electrical_preorder_system/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobile_electrical_preorder_system/core/network/firebase_messaging/set_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getDeviceToken();
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

Future<void> getDeviceToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $token');
  // Lưu token này lên server hoặc dùng để test gửi thông báo
}
