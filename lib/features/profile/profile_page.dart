import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/user_network.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/res/index.dart';
import 'package:mobile_electrical_preorder_system/features/profile/partials/details.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  User? _currentUser;
  bool _isLoading = true;
  final UserNetwork _userNetwork = UserNetwork();

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
    setState(() {
      _isLoading = true;
    });

    try {
      final accessToken = await TokenService.getAccessToken();
      if (accessToken != null) {
        final decodedToken = await TokenService.decodeAccessToken(accessToken);

        if (mounted) {
          setState(() {
            userData = decodedToken;
          });
        }

        // Lấy ID người dùng từ token đã giải mã
        final userId = decodedToken != null ? decodedToken['id'] : null;
        if (userId != null) {
          try {
            // Gọi API để lấy thông tin chi tiết của người dùng
            final user = await _userNetwork.getUserById(userId);

            if (mounted) {
              setState(() {
                _currentUser = user;
                _isLoading = false;
              });
            }
          } catch (e) {
            print('Error fetching user details: $e');
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          }
        } else {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';

    List<String> nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return nameParts.first[0].toUpperCase() + nameParts.last[0].toUpperCase();
    } else {
      return nameParts.first[0].toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userRole = userData?['role'];
    String fullName = _currentUser?.fullname ?? userData?['fullName'] ?? 'User';
    String email = _currentUser?.email ?? userData?['email'] ?? '';

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
                    child: RefreshIndicator(
                      onRefresh: _loadUserData,
                      color: Color(0xFF1A237E),
                      backgroundColor: Colors.white,
                      strokeWidth: 5,
                      displacement: 60,
                      child: Column(
                        children: [
                          // Back button
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              top: 8.0,
                            ),
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
                                    GoRouter.of(context).pop();
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
                                SizedBox(height: 2),
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
                                  child:
                                      _currentUser != null &&
                                              _currentUser!.avatar.isNotEmpty
                                          ? CircleAvatar(
                                            radius: 45,
                                            backgroundImage: NetworkImage(
                                              _currentUser!.avatar,
                                            ),
                                            backgroundColor: Color(
                                              0xFF1A237E,
                                            ).withOpacity(0.1),
                                          )
                                          : CircleAvatar(
                                            radius: 45,
                                            backgroundColor: Color(
                                              0xFF1A237E,
                                            ).withOpacity(0.2),
                                            child: Text(
                                              _getInitials(fullName),
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                ),
                                SizedBox(height: 5),
                                // User name
                                Text(
                                  fullName,
                                  style: TextStyle(
                                    fontSize: 22,
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
                                  email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                SizedBox(height: 15),
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
                                    icon: Icons.notifications,
                                    title: 'Thông báo',
                                    color: Color(0xFF1A237E),
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
          } else if (title == 'Thông tin chung') {
            // Lấy userId từ userData hoặc _currentUser
            String? userId = _currentUser?.id ?? userData?['id'];

            // Điều hướng đến trang chi tiết thông tin người dùng
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfileDetailsPage(userId: userId),
              ),
            );
          }
          // Handle other options
        },
      ),
    );
  }
}
