import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';

// Pages
import 'package:mobile_electrical_preorder_system/features/staff/overview/index.dart';
import 'package:mobile_electrical_preorder_system/features/staff/statistic/index.dart';
import 'package:mobile_electrical_preorder_system/features/staff/customer/index.dart';
import 'package:mobile_electrical_preorder_system/features/staff/order/index.dart';

class StaffLayout extends StatefulWidget {
  final Widget child;

  const StaffLayout({Key? key, required this.child}) : super(key: key);

  @override
  _ManagerLayoutState createState() => _ManagerLayoutState();
}

class _ManagerLayoutState extends State<StaffLayout> {
  int _selectedIndex = 0;
  String _fullName = 'Staff';
  Widget get child => _pages[_selectedIndex];

  final List<Widget> _pages = [
    OverviewPage(),
    StatisticPage(),
    CustomerManagerPage(),
    ManagerOrdersPage(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home, size: 30),
      label: 'Tổng quan',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.campaign, size: 30),
      label: 'Đơn Hàng',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people, size: 30),
      label: 'Khách hàng',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt, size: 30),
      label: 'Thống kê',
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
      body: child, // Use the child widget here instead of IndexedStack
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Xin chào, $_fullName',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [_buildPopupMenu()],
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      offset: Offset(0, 60),
      icon: CircleAvatar(
        backgroundColor: Colors.black,
        child: Text(_fullName[0], style: TextStyle(color: Colors.white)),
      ),
      color: Colors.white,
      onSelected: (value) {
        if (value == 'logout') {
          _logout();
        } else if (value == 'profile') {
          Helper.navigateTo(context, '/staff/profile');
        }
      },
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: 'profile',
              child: ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Thông tin tài khoản'),
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Đăng xuất'),
                textColor: Colors.red,
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
        selectedItemColor: Colors.redAccent,
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
