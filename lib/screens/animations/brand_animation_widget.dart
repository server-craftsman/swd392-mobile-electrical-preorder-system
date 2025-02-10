import 'package:flutter/material.dart';

class BrandAnimationWidget extends StatelessWidget {
  final Animation<double> opacityAnimation;
  final Animation<Offset> slideAnimation;
  final Animation<double> scaleAnimation;
  final Animation<double> rotationAnimation;

  const BrandAnimationWidget({
    Key? key,
    required this.opacityAnimation,
    required this.slideAnimation,
    required this.scaleAnimation,
    required this.rotationAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: slideAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: RotationTransition(
                  turns: rotationAnimation,
                  child: Icon(
                    Icons.flash_on, // Replace with your logo icon
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeTransition(
              opacity: opacityAnimation,
              child: Text(
                'Elecee',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
