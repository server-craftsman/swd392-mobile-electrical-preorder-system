import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/screens/animations/initial_animation_screen.dart';
import 'package:mobile_electrical_preorder_system/core/routing/run/app_router.dart';
import 'package:mobile_electrical_preorder_system/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobile_electrical_preorder_system/core/network/firebase_messaging/firebase_api.dart';
import 'package:flutter/services.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for a more immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await Firebase.initializeApp();
  final firebaseApi = FirebaseApi();
  await firebaseApi.initNotification();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  runApp(const InitialAnimationApp());
}

class InitialAnimationApp extends StatelessWidget {
  const InitialAnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InitialAnimationScreen(),
      debugShowCheckedModeBanner: false,
      // navigatorKey: navigatorKey,
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
