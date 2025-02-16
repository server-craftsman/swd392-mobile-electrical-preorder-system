import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () {
            Helper.navigateTo(context, '/login');
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset('assets/images/logo.jpg', height: 40),
            ),
            SizedBox(width: 8),
            Text('Elecee', style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz_outlined, color: Colors.grey),
            onPressed: () {
              // Add action here
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tạo tài khoản',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            _buildTextField('Họ và tên', 'Nhập họ và tên của bạn'),
            SizedBox(height: 16),
            _buildTextField('Email', 'Nhập email của bạn'),
            SizedBox(height: 16),
            _buildTextField('Mật khẩu', 'Tạo mật khẩu', obscureText: true),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Helper.navigateTo(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  'Đăng ký',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('Đăng ký với tài khoản mạng xã hội'),
            SizedBox(height: 16),
            _buildSocialIcons(),
            SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                Helper.navigateTo(context, '/login');
              },
              child: Text.rich(
                TextSpan(
                  text: 'Đã có tài khoản? ',
                  children: [
                    TextSpan(
                      text: 'Đăng nhập ở đây',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    bool obscureText = false,
  }) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSocialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(Icons.facebook),
        SizedBox(width: 16),
        _buildSocialIcon(
          Icons.g_mobiledata_sharp,
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, {TextStyle? style}) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      child: Icon(icon, color: style?.color ?? Colors.blue),
    );
  }
}
