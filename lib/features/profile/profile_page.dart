import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Helper.navigateTo(context, '/');
  }

  Future<void> _loadUserData() async {
    final accessToken = await TokenService.getAccessToken();
    if (accessToken != null) {
      final decodedToken = await TokenService.decodeAccessToken(accessToken);
      if (mounted) {
        setState(() {
          userData = decodedToken;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userRole = userData?['role'];

    return Scaffold(
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(color: Color(0xFF1A237E)),
              )
              : Stack(
                children: [
                  // Gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF1A237E),
                          Color(0xFF3949AB),
                          Color(0xFFF5F5F5),
                          Color(0xFFF5F5F5),
                        ],
                        stops: [0.0, 0.3, 0.3, 1.0],
                      ),
                    ),
                  ),

                  // Main content
                  SafeArea(
                    child: Column(
                      children: [
                        // Back button
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (userRole == 'ROLE_ADMIN') {
                                    GoRouter.of(context).pop();
                                  } else {
                                    GoRouter.of(context).pop();
                                  }
                                },
                                tooltip: 'Quay lại',
                              ),
                            ),
                          ),
                        ),

                        // Profile header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              // User avatar with border
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 10,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 45, // Reduced from 60
                                  backgroundImage: AssetImage(
                                    'assets/images/Tham-Nho/tham3.jpg',
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              // User name
                              Text(
                                userData?['fullName'] ??
                                    'Admin', // Changed default text
                                style: TextStyle(
                                  fontSize: 22, // Reduced from 26
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2),
                              // User email
                              Text(
                                userData?['email'] ?? 'huyit2003@gmail.com',
                                style: TextStyle(
                                  fontSize: 14, // Reduced from 16
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              SizedBox(height: 15), // Reduced from 20
                            ],
                          ),
                        ),

                        // Profile options
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, -5),
                                ),
                              ],
                            ),
                            child: ListView(
                              padding: EdgeInsets.only(top: 25),
                              children: [
                                _buildProfileOption(
                                  icon: Icons.person,
                                  title: 'Thông tin chung',
                                  color: Color(0xFF1A237E),
                                ),
                                _buildProfileOption(
                                  icon: Icons.apps,
                                  title: 'Tài khoản và ứng dụng',
                                  color: Color(0xFF3949AB),
                                ),
                                _buildProfileOption(
                                  icon: Icons.security,
                                  title: 'Bảo mật',
                                  color: Color(0xFF5C6BC0),
                                ),
                                _buildProfileOption(
                                  icon: Icons.upgrade,
                                  title: 'Nâng cấp gói',
                                  color: Color(0xFF7986CB),
                                ),
                                _buildProfileOption(
                                  icon: Icons.payment,
                                  title: 'Thanh toán',
                                  color: Color(0xFF9FA8DA),
                                ),
                                _buildProfileOption(
                                  icon: Icons.notifications,
                                  title: 'Thông báo',
                                  color: Color(0xFFC5CAE9),
                                ),
                                _buildProfileOption(
                                  icon: Icons.logout,
                                  title: 'Đăng xuất',
                                  color: Colors.redAccent,
                                  isLogout: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required Color color,
    bool isLogout = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color:
            isLogout ? Colors.red.withOpacity(0.05) : color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
                isLogout ? Colors.red.withOpacity(0.1) : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isLogout ? Colors.red : Colors.grey,
        ),
        onTap: () {
          if (isLogout) {
            _logout();
          }
          // Handle other options
        },
      ),
    );
  }
}
