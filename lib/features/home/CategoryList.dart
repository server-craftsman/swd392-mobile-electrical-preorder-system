import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/network/category/category_network.dart';
import 'package:mobile_electrical_preorder_system/core/network/category/category_model.dart';
// import 'package:mobile_electrical_preorder_system/core/network/category/category_response.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  Future<List<Category>> _fetchCategories() async {
    try {
      final fetchedCategories = await CategoryNetwork().getCategories();
      return fetchedCategories.data;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: snapshot.data!.isNotEmpty
                ? snapshot.data!.map((category) {
                    return _buildCategoryIcon(Icons.category, category.name,
                        color: Colors.blueAccent);
                  }).toList()
                :
                // [
                //     _buildCategoryIcon(Icons.phone_android, 'Điện thoại',
                //         color: Colors.redAccent),
                //     _buildCategoryIcon(Icons.laptop, 'Laptop',
                //         color: Colors.blueAccent),
                //     _buildCategoryIcon(Icons.watch, 'Đồng hồ',
                //         color: Colors.greenAccent),
                //   ],
                [Text('No categories found')],
          );
        }
      },
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label,
      {required Color color}) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}
