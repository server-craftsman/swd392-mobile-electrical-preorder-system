import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/theme/app_theme.dart';
import 'package:mobile_electrical_preorder_system/features/home/home_page.dart';
import 'package:mobile_electrical_preorder_system/layouts/main_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart'; // Import for rootBundle

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkFirstTime(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child:
                    CircularProgressIndicator(), // Temporary loading indicator
              ),
            ),
          );
        } else {
          final isFirstTime = snapshot.data ?? true;
          return MaterialApp(
            title: 'Elecee System',
            theme: AppTheme.lightTheme.copyWith(
              textTheme: Theme.of(context).textTheme.apply(
                    fontFamily: 'Poppins',
                  ),
            ),
            home: isFirstTime
                ? Scaffold(
                    body: Center(
                      child: FutureBuilder(
                        future: Future.delayed(Duration(seconds: 5), () {
                          return rootBundle
                              .loadString('assets/animations/first_time.json');
                        }),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Lottie.asset(
                                'assets/animations/first_time.json');
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  )
                : MainLayout(
                    child: Stack(
                      children: [
                        HomePage(),
                      ],
                    ),
                  ),
            debugShowCheckedModeBanner: false, // Loại bỏ banner debug
          );
        }
      },
    );
  }

  Future<bool> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }
    return isFirstTime;
  }
}
