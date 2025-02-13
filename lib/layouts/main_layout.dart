import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  const MainLayout({required this.child, super.key});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedIndex();
  }

  Future<void> _loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = prefs.getInt('selectedIndex') ?? 0;
    });
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedIndex', index);

    // Xử lý điều hướng đến các trang khác nhau dựa trên chỉ số
    switch (index) {
      case 0:
        Helper.navigateTo(context, '/');
        break;
      case 1:
        Helper.navigateTo(context, '/category');
        break;
      case 2:
        Helper.navigateTo(context, '/favorite');
        break;
      case 3:
        Helper.navigateTo(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            children: [
              TextSpan(
                text: 'Elec',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: 'ee',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          widget.child,
        ],
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30),
                label: 'Trang chủ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view, size: 30),
                label: 'Danh mục',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite, size: 30),
                label: 'Yêu thích',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 30),
                label: 'Hồ sơ',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            onTap: _onItemTapped,
          ),
        ],
      ),
    );
  }

  Positioned cart() {
    return Positioned(
      bottom: 30,
      right: MediaQuery.of(context).size.width / 2 - 30,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            FloatingActionButton(
              onPressed: () {},
              backgroundColor: const Color.fromARGB(255, 248, 147, 147),
              child: const Icon(Icons.shopping_cart,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
