import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/network/category/category_network.dart';
// import 'UserProfile.dart';
import 'SearchBar.dart';
import 'ImageCarousels.dart';
import 'CategoryList.dart';
import 'OrderHistory.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final fetchedCategories = await CategoryNetwork().getCategories();
      setState(() {
        categories =
            (fetchedCategories.data as List).map((e) => e.toString()).toList();
      });
    } catch (e) {
      print('Failed to fetch categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // UserProfile(),
          const SizedBox(height: 20),
          const CustomSearchBar(),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageCarousel(),
                  const SizedBox(height: 20),
                  Text(
                    'Danh mục',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  CategoryList(),
                  const SizedBox(height: 20),
                  Text(
                    'Đơn hàng trước đây',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  OrderHistory(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
