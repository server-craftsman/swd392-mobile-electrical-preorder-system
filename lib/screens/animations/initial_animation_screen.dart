import 'package:flutter/material.dart';
import 'animation_origin.dart'; // Import your existing animation
import 'package:mobile_electrical_preorder_system/main.dart'; // Import the main.dart file

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
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward().whenComplete(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FirstAnimation(animation: _animationController),
    );
  }
}
