import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/theme/app_theme.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';

class WelcomePage extends StatelessWidget {
  final List<Map<String, String>> items = [
    {
      'title': 'Personalize',
      'description':
          'Choose the best style for your project match with branding'
    },
    {
      'title': 'Customize',
      'description':
          'We have predefined 10+ color schemes and with scss you can create new.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/tham.jpg'),
            fit: BoxFit.cover,
            opacity: 0.9,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.palette,
                size: 80,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              SizedBox(height: 30),
              Text(
                'Electrical Preorder System',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 246, 12, 12),
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 10,
                    ),
                    onPressed: () {
                      Helper.navigateWithAnimation(context, '/login');
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: 2),
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 10,
                    ),
                    onPressed: () {
                      Helper.navigateTo(context, '/login');
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
