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
  Animation<double>? _scaleAnimation; // Changed to nullable

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.7, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.easeOutQuint),
      ),
    );

    // Initialize scale animation properly
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
    print('CustomWelcomePage initialized');
  }

  @override
  void dispose() {
    _animationController.dispose();
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
          // Gradient Background instead of image
          Container(
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
          ),

          // Decorative elements
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          Positioned(
            bottom: 150,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // Logo and Title with enhanced animations
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation ?? const AlwaysStoppedAnimation(1.0),
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 120),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.6),
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.jpg',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Electrical Preorder System',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 3,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Giải pháp thông minh cho cuộc sống hiện đại',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Enhanced bottom sheet
          SlideTransition(
            position: _slideAnimation,
            child: DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.35,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Improved drag handle
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              30.0,
                              10.0,
                              30.0,
                              30.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chào mừng bạn',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Bắt đầu quản lý dự án và kết nối với đội ngũ của bạn',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: 30),

                                // Stylish login button
                                Container(
                                  width: double.infinity,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF1A237E),
                                        Color(0xFF3949AB),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(
                                          0xFF1A237E,
                                        ).withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(15),
                                      onTap: () {
                                        if (mounted) {
                                          Helper.navigateTo(context, '/login');
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          'Đăng nhập',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                // Optional: Uncomment if you want to add sign up option
                                /*
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Chưa có tài khoản? ',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (mounted) {
                                          Helper.navigateTo(context, '/signup');
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Đăng ký',
                                        style: TextStyle(
                                          color: Color(0xFF1A237E),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                */
                                SizedBox(height: 30),

                                // Feature highlights
                                _buildFeatureItem(
                                  Icons.electric_bolt,
                                  'Sản phẩm điện tử chất lượng cao',
                                  'Đặt hàng trước các sản phẩm điện tử mới nhất',
                                ),

                                SizedBox(height: 20),

                                _buildFeatureItem(
                                  Icons.delivery_dining,
                                  'Giao hàng nhanh chóng',
                                  'Theo dõi đơn hàng và nhận thông báo cập nhật',
                                ),

                                SizedBox(height: 20),

                                _buildFeatureItem(
                                  Icons.support_agent,
                                  'Hỗ trợ 24/7',
                                  'Đội ngũ hỗ trợ luôn sẵn sàng giúp đỡ bạn',
                                ),
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

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF1A237E).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Color(0xFF1A237E), size: 24),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double largerBlurRadius() {
    return 20.0;
  }
}
