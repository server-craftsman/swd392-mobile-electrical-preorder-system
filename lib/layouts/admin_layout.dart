import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';

// Pages
import 'package:mobile_electrical_preorder_system/features/admin/overview/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/campaign/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/user/index.dart';
import 'package:mobile_electrical_preorder_system/features/admin/order/index.dart';
import 'package:mobile_electrical_preorder_system/features/profile/profile_page.dart';

class AdminLayout extends StatefulWidget {
  @override
  _AdminLayoutState createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;
  String _fullName = 'Admin';

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
    final prefs = await SharedPreferences.getInstance();
    final accessToken = await TokenService.getAccessToken();

    setState(() {
      _selectedIndex = prefs.getInt('selectedIndex') ?? 0;
    });

    if (accessToken != null) {
      final decodedToken = await TokenService.decodeAccessToken(accessToken);
      if (decodedToken != null && decodedToken.containsKey('fullName')) {
        setState(() {
          _fullName = decodedToken['fullName'];
        });
      }
    }
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
          Column(
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
                ),
              ),
            ],
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
          icon: Icon(Icons.notifications_outlined, color: Color(0xFF1A237E)),
          onPressed: () {
            // Handle notifications
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
      icon: CircleAvatar(
        backgroundColor: Color(0xFF1A237E),
        child: Text(
          _fullName[0].toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
}
