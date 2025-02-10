import 'package:flutter/material.dart';

class BrandAnimationLogic {
  final AnimationController controller;
  late final Animation<double> opacityAnimation;
  late final Animation<Offset> slideAnimation;
  late final Animation<double> scaleAnimation;
  late final Animation<double> rotationAnimation;

  BrandAnimationLogic({required TickerProvider vsync})
      : controller = AnimationController(
          duration: const Duration(seconds: 3),
          vsync: vsync,
        ) {
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );

    slideAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    rotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  void dispose() {
    controller.dispose();
  }
}
