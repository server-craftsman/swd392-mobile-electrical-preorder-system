import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/tham.jpg'),
            ),
            SizedBox(height: 16),
            Text(
              'Nguyễn Đan Huy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'huyit2003@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Thông tin chung'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.apps),
                    title: Text('Tài khoản và ứng dụng'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.security),
                    title: Text('Bảo mật'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.upgrade),
                    title: Text('Nâng cấp gói'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text('Thanh toán'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Thông báo'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Xóa tài khoản'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
