import 'package:flutter/material.dart';

class ProductManagementPage extends StatelessWidget {
  final List<Map<String, String>> products = [
    {'name': 'Product A', 'price': '\$50', 'stock': '10', 'status': 'Open'},
    {'name': 'Product B', 'price': '\$30', 'stock': '5', 'status': 'Closed'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Management')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index]['name']!),
            subtitle: Text('Price: ${products[index]['price']} - Stock: ${products[index]['stock']}'),
            trailing: Text(products[index]['status']!),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}