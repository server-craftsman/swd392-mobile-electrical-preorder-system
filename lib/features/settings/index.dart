import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Custom width for the drawer
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_circle, color: Colors.white),
                title: Text('Profile', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Helper.navigateWithAnimation(context, '/profile');
                  // Handle profile tap
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications, color: Colors.white),
                title: Text(
                  'Notifications',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Helper.navigateWithAnimation(context, '/notifications');
                  // Handle notifications tap
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text('General', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Helper.navigateWithAnimation(context, '/general');
                  // Handle general settings tap
                },
              ),
              // Add more ListTiles for other settings
            ],
          ),
        ),
      ),
    );
  }
}
