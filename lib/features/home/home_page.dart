import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/tham.jpg'),
                    radius: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Nguyễn Đan Huy\n0869872830',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search Anything...',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontStyle: FontStyle.italic,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VerticalDivider(
                    color: Colors.grey.shade400,
                    thickness: 1,
                    width: 1,
                  ),
                  Icon(Icons.mic, color: Colors.grey.shade400),
                ],
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Happy Weekend\n25% OFF',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryIcon(Icons.local_grocery_store, 'Groceries'),
              _buildCategoryIcon(Icons.devices, 'Appliances'),
              _buildCategoryIcon(Icons.checkroom, 'Fashion'),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Previous Order',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Add more widgets as needed
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.redAccent,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}
