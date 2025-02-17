import 'package:flutter/material.dart';

class ManageCampaignPage extends StatelessWidget {
  final List<String> campaigns = [
    'Chiến dịch 1',
    'Chiến dịch 2',
    'Chiến dịch 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý chiến dịch'),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: campaigns.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(campaigns[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Implement edit functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Implement delete functionality
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add campaign functionality
        },
        hoverColor: Colors.black,
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
    );
  }
}
