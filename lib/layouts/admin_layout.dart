import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLayout extends StatefulWidget {
  final Widget child;
  const AdminLayout({required this.child, super.key});

  @override
  _AdminLayoutState createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSelectedIndex();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _selectedIndex = prefs.getInt('selectedIndex') ?? 0;
      });
    }
  }

  void _onItemTapped(int index) async {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedIndex', index);

    switch (index) {
      case 0:
        Helper.navigateTo(context, '/admin/dashboard');
        break;
      case 1:
        Helper.navigateTo(context, '/admin/campaigns');
        break;
      case 2:
        Helper.navigateTo(context, '/admin/users');
        break;
      case 3:
        Helper.navigateTo(context, '/admin/orders');
        break;
      case 4:
        Helper.navigateTo(context, '/admin/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Chào Admin, Huy IT',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Spacer(),
            CircleAvatar(backgroundImage: AssetImage('assets/images/tham.jpg')),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
      ),
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          selectedLabelStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(color: Colors.transparent),
          items: const <BottomNavigationBarItem>[
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
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 255, 89, 89),
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.transparent,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
