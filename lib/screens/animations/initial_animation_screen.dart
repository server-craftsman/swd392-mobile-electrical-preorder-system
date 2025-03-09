import 'package:flutter/material.dart';
import 'animation_origin.dart';
import 'package:mobile_electrical_preorder_system/main.dart';

class InitialAnimationScreen extends StatefulWidget {
  @override
  _InitialAnimationScreenState createState() => _InitialAnimationScreenState();
}

class _InitialAnimationScreenState extends State<InitialAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Start animation and navigate after completion
    _animationController.forward();

    // Add a delay before navigation to allow users to see the animation
    Future.delayed(Duration(milliseconds: 3200), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => const MyApp(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: FirstAnimation(animation: _animationController));
  }
}
