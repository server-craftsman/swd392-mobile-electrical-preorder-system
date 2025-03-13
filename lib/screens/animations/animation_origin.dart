import 'package:flutter/material.dart';

// First animation
class FirstAnimation extends StatelessWidget {
  final Animation<double> animation;

  const FirstAnimation({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A237E), // Deep indigo
            Color(0xFF303F9F), // Indigo
            Color(0xFF3949AB), // Lighter indigo
          ],
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with elegant animation
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Interval(0.0, 0.7, curve: Curves.elasticOut),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 25,
                        spreadRadius: 5,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 4,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.jpg',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // App name with elegant fade and slide
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Interval(0.4, 1.0, curve: Curves.easeIn),
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Interval(0.4, 1.0, curve: Curves.easeOutQuart),
                    ),
                  ),
                  child: Text(
                    'Electrical Preorder System',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Subtle tagline
              const SizedBox(height: 16),
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Interval(0.6, 1.0, curve: Curves.easeIn),
                ),
                child: Text(
                  'Giải pháp thông minh cho cuộc sống hiện đại',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
