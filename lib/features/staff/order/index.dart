import 'package:flutter/material.dart';

class ManagerOrdersPage extends StatefulWidget {
  const ManagerOrdersPage({Key? key}) : super(key: key);

  @override
  State<ManagerOrdersPage> createState() => _ManagerOrdersPageState();
}

class _ManagerOrdersPageState extends State<ManagerOrdersPage> {
  final List<Map<String, String>> orders = [
    {
      'id': 'PO001',
      'customer': 'John Doe',
      'date': '2025-03-06',
      'status': 'Pending',
      'total': '\$100',
    },
    {
      'id': 'PO002',
      'customer': 'Jane Smith',
      'date': '2025-03-05',
      'status': 'Confirmed',
      'total': '\$150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pre-order List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text('Order ${order['id']} - ${order['customer']}'),
                  subtitle: Text('${order['date']} - ${order['status']}'),
                  trailing: Text(order['total']!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsPage(order: order),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  final Map<String, String> order;

  OrderDetailsPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Details - ${order['id']}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer: ${order['customer']}',
              style: TextStyle(fontSize: 18),
            ),
            Text('Date: ${order['date']}'),
            Text('Status: ${order['status']}'),
            SizedBox(height: 16),
            Text(
              'Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(title: Text('Product A'), subtitle: Text('Qty: 2 - \$50')),
            Divider(),
            Text(
              'Total: ${order['total']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: Text('Confirm')),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
