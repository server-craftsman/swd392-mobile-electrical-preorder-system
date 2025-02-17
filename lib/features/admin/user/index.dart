import 'package:flutter/material.dart';

class CustomerManagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khách hàng', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            // Handle back action
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white),
                SizedBox(width: 5),
                DropdownButton<String>(
                  value: 'January',
                  dropdownColor: Colors.black,
                  iconEnabledColor: Colors.white,
                  underline: Container(),
                  items:
                      <String>['January', 'February', 'March'].map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    // Handle month change
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSelector(),
            SizedBox(height: 20),
            _buildStatistics(),
            SizedBox(height: 20),
            Expanded(child: _buildRecentTransactions()), // Fix overflow
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle see more action
                },
                child: Text('See More'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildDateItem('Mon', '17', false),
          _buildDateItem('Tue', '18', false),
          _buildDateItem('Wed', '20', true),
          _buildDateItem('Thu', '21', false),
          _buildDateItem('Fri', '22', false),
          _buildDateItem('Sat', '23', false),
          _buildDateItem('Sun', '24', false),
        ],
      ),
    );
  }

  Widget _buildDateItem(String day, String date, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          Text(day, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 5),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF002B1F) : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                date,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Column(
      children: [
        _buildStatisticCardWithIcon(
          'Tổng doanh thu',
          '73.820',
          'Đạt mục tiêu',
          Icons.donut_large,
          progress: 0.8,
        ),
        SizedBox(height: 10),
        _buildStatisticCardWithIcon(
          'Khách hàng mới',
          '520',
          '+0.8%',
          Icons.person_add,
        ),
        SizedBox(height: 10),
        _buildStatisticCardWithIcon(
          'Khách hàng hoạt động',
          '1.2K',
          '+23%',
          Icons.people,
        ),
      ],
    );
  }

  Widget _buildStatisticCardWithIcon(
    String title,
    String value,
    String subtitle,
    IconData icon, {
    double? progress,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(title, style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (progress != null) ...[
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
              ),
            ],
            SizedBox(height: 10),
            Text(subtitle, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return ListView(
      children: [
        Text(
          'Recent Transaction',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildTransactionItem(
          'Matt Sanderson',
          '11 May 2023',
          '+\$1400',
          Colors.green,
        ),
        _buildTransactionItem(
          'Anatasya Gabriella',
          '20 Jan 2024',
          '-\$800',
          Colors.red,
        ),
        _buildTransactionItem(
          'Eliot Russel',
          '14 Feb 2024',
          '+\$1400',
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    String name,
    String date,
    String amount,
    Color amountColor,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
        radius: 24,
      ),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(date, style: TextStyle(color: Colors.grey)),
      trailing: Text(
        amount,
        style: TextStyle(
          color: amountColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
