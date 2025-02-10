import 'package:flutter/material.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  const AdminLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: child,
    );
  }
}
