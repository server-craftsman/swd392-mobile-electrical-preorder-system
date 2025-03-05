import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';

class CustomWelcomePage extends StatefulWidget {
  @override
  _CustomWelcomePageState createState() => _CustomWelcomePageState();
}

class _CustomWelcomePageState extends State<CustomWelcomePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    print('CustomWelcomePage initialized');
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Ensure the ScrollController is not attached to any Scrollable before disposing
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
    _scrollController.dispose();
    print('CustomWelcomePage disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('CustomWelcomePage build');
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Electrical Preorder System',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: DraggableScrollableSheet(
              initialChildSize: 0.3, // Adjust initial size as needed
              minChildSize: 0.3,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: largerBlurRadius(),
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Add an icon to indicate draggable area
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.drag_handle_sharp,
                          color: Colors.grey,
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bắt đầu quản lý dự án của bạn',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'và kết nối với đội ngũ của bạn',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Divider(),
                                // ListTile(
                                //   title: Text("Không có tài khoản"),
                                //   trailing: TextButton(
                                //     onPressed: () {
                                //       if (mounted) {
                                //         Helper.navigateTo(context, '/signup');
                                //       }
                                //     },
                                //     child: Text(
                                //       'Đăng ký',
                                //       style: TextStyle(
                                //         color: Colors.blue,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                ListTile(
                                  title: Text('Vui lòng đăng nhập để tiếp tục'),
                                  trailing: TextButton(
                                    onPressed: () {
                                      if (mounted) {
                                        Helper.navigateTo(context, '/login');
                                      }
                                    },
                                    child: Text(
                                      'Đăng nhập',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Text(
                                //       'Đăng nhập với tài khoản mạng xã hội',
                                //       style: TextStyle(
                                //         color: Colors.grey,
                                //         fontWeight: FontWeight.normal,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // SizedBox(height: 8),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     IconButton(
                                //       icon: Icon(
                                //         Icons.facebook,
                                //         color: Colors.blue,
                                //       ),
                                //       onPressed: () {
                                //         // Facebook login
                                //       },
                                //     ),
                                //     IconButton(
                                //       icon: Icon(
                                //         Icons.g_mobiledata_rounded,
                                //         color: Colors.red,
                                //       ),
                                //       onPressed: () {
                                //         // Google login
                                //       },
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double largerBlurRadius() {
    return 20.0; // Adjusted blur radius to avoid assertion error
  }
}
