import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/user_network.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/res/index.dart';

// Pages
import 'package:mobile_electrical_preorder_system/features/admin/overview/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/campaign/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/user/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/order/index.dart';
import 'package:mobile_electrical_preorder_system/features/profile/profile_page.dart';
import 'package:mobile_electrical_preorder_system/features/notification_page/index.dart';
import 'package:mobile_electrical_preorder_system/core/network/notification/notification.network.dart';

class AdminLayout extends StatefulWidget {
  @override
  _AdminLayoutState createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;
  String _fullName = 'Admin';
  String _userId = '';
  User? _currentUser;
  final UserNetwork _userNetwork = UserNetwork();
  bool _isLoading = true;

  final List<Widget> _pages = [
    DashboardPage(),
    ManageCampaignPage(),
    CustomerManagePage(),
    AdminOrdersPage(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home, size: 30),
      label: 'Tổng quan',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.campaign, size: 30),
      label: 'Chiến dịch',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people, size: 30),
      label: 'Người dùng',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt, size: 30),
      label: 'Đơn hàng',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final accessToken = await TokenService.getAccessToken();

    setState(() {
      _selectedIndex = prefs.getInt('selectedIndex') ?? 0;
    });

    if (accessToken != null) {
      final decodedToken = await TokenService.decodeAccessToken(accessToken);
      if (decodedToken != null) {
        // Set basic user info from token
        if (decodedToken.containsKey('fullName')) {
          _fullName = decodedToken['fullName'];
        }

        // Get user ID from token and fetch complete user details
        if (decodedToken.containsKey('id')) {
          _userId = decodedToken['id'].toString();
          try {
            final userDetails = await _userNetwork.getUserById(_userId);
            if (userDetails != null) {
              setState(() {
                _currentUser = userDetails;
                // Update fullName with the one from complete user details
                _fullName = userDetails.fullname;
              });
            }
          } catch (e) {
            print('Error fetching user details: $e');
          }
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Helper.navigateTo(context, '/');
  }

  void _onItemTapped(int index) async {
    if (_selectedIndex != index) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('selectedIndex', index);
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF1A237E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.electric_bolt,
              color: Color(0xFF1A237E),
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào,',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _fullName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1A237E),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      actions: [
        IconButton(
          icon: Stack(
            children: [
              Icon(Icons.notifications_outlined, color: Color(0xFF1A237E)),
              Positioned(
                right: 0,
                top: 0,
                child: FutureBuilder<int>(
                  future: _getUnreadNotificationsCount(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data! > 0) {
                      return Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          snapshot.data! > 9 ? '9+' : '${snapshot.data}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()),
            );
          },
        ),
        _buildPopupMenu(),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      offset: Offset(0, 60),
      icon:
          _currentUser?.avatar != null && _currentUser!.avatar.isNotEmpty
              ? CircleAvatar(
                backgroundImage: NetworkImage(_currentUser!.avatar),
                backgroundColor: Color(0xFF1A237E).withOpacity(0.2),
              )
              : CircleAvatar(
                backgroundColor: Color(0xFF1A237E),
                child: Text(
                  _getInitials(_fullName),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'logout') {
          _logout();
        } else if (value == 'profile') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        }
      },
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: 'profile',
              child: ListTile(
                leading: Icon(Icons.account_circle, color: Color(0xFF1A237E)),
                title: Text(
                  'Thông tin tài khoản',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Đăng xuất',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
          ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        selectedItemColor: Color(0xFF1A237E),
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.transparent,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(color: Colors.transparent),
        items: _navItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Helper method to get initials from name
  String _getInitials(String name) {
    if (name.isEmpty) return '';

    List<String> nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return nameParts.first[0].toUpperCase() + nameParts.last[0].toUpperCase();
    } else {
      return nameParts.first[0].toUpperCase();
    }
  }

  Future<int> _getUnreadNotificationsCount() async {
    if (_userId.isEmpty) return 0;

    try {
      final NotificationNetwork notificationNetwork = NotificationNetwork();
      return await notificationNetwork.getUnreadNotificationCount(_userId);
    } catch (e) {
      print('Error getting unread notification count: $e');
      return 0;
    }
  }
}
