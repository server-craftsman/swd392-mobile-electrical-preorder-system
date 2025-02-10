import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/screens/animations/brand_animation_logic.dart';
import 'package:mobile_electrical_preorder_system/screens/animations/brand_animation_widget.dart';
import 'package:mobile_electrical_preorder_system/layouts/main_layout.dart';
import 'package:mobile_electrical_preorder_system/features/home/home_page.dart';

class BrandAnimationScreen extends StatefulWidget {
  @override
  _BrandAnimationScreenState createState() => _BrandAnimationScreenState();
}

class _BrandAnimationScreenState extends State<BrandAnimationScreen>
    with SingleTickerProviderStateMixin {
  late final BrandAnimationLogic _animationLogic;

  @override
  void initState() {
    super.initState();
    _animationLogic = BrandAnimationLogic(vsync: this);

    _animationLogic.controller.forward().then((_) {
      // Navigate to MainLayout after animation
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => MainLayout(
                  child: Stack(
                    children: [
                      HomePage(),
                    ],
                  ),
                )),
      );
    });
  }

  @override
  void dispose() {
    _animationLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BrandAnimationWidget(
        opacityAnimation: _animationLogic.opacityAnimation,
        slideAnimation: _animationLogic.slideAnimation,
        scaleAnimation: _animationLogic.scaleAnimation,
        rotationAnimation: _animationLogic.rotationAnimation,
      ),
    );
  }
}
