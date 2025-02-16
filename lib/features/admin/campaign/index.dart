import 'package:flutter/material.dart';

void main() {
  runApp(CampaignApp());
}

class CampaignApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CampaignListScreen());
  }
}

class CampaignListScreen extends StatelessWidget {
  final List<Campaign> campaigns = [
    Campaign(
      name: 'Hóa đơn cho khách hàng',
      category: 'Hệ thống đặt trước',
      members: 9,
    ),
    Campaign(
      name: 'Thiết kế trang web Dribble',
      category: 'Hệ thống đặt trước',
      members: 3,
    ),
    Campaign(
      name: 'Thiết kế ứng dụng Envanto',
      category: 'Hệ thống đặt trước',
      members: 4,
    ),
    Campaign(
      name: 'Phát triển Dropbox',
      category: 'Hệ thống đặt trước',
      members: 7,
    ),
    Campaign(
      name: 'Mẫu ứng dụng Sketch',
      category: 'Hệ thống đặt trước',
      members: 6,
    ),
    Campaign(
      name: 'Trình bày Dribble',
      category: 'Hệ thống đặt trước',
      members: 9,
    ),
    Campaign(
      name: 'Trang web mới của Spotify',
      category: 'Hệ thống đặt trước',
      members: 3,
    ),
    Campaign(
      name: 'Tài nguyên nhóm Slack',
      category: 'Hệ thống đặt trước',
      members: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Sort', style: TextStyle(color: Colors.black)),
            SizedBox(width: 8),
            DropdownButton<String>(
              underline: Container(),
              items:
                  <String>['A-Z', 'Z-A'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  // Sort functionality
                }
              },
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.view_list, color: Colors.black),
              onPressed: () {
                // Change view functionality
              },
            ),
            IconButton(
              icon: Icon(Icons.grid_view, color: Colors.black),
              onPressed: () {
                // Change view functionality
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: campaigns.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey, width: 1),
              ),
              child: ListTile(
                tileColor: Colors.white, // Set background to white
                onTap: () {
                  // Handle tap
                },
                leading: CircleAvatar(
                  backgroundColor: const Color.fromARGB(
                    255,
                    130,
                    130,
                    130,
                  ), // Placeholder for image
                  child: Text(
                    campaigns[index].name[0],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  campaigns[index].name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  campaigns[index].category,
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: CircleAvatar(
                  backgroundColor: const Color.fromARGB(
                    255,
                    130,
                    130,
                    130,
                  ), // Placeholder for image
                  child: Text(
                    '+${campaigns[index].members}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Campaign {
  final String name;
  final String category;
  final int members;

  Campaign({required this.name, required this.category, required this.members});
}
