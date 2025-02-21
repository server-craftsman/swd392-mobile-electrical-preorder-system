import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(context),
                SizedBox(height: 20),
                _buildUpdateCard(),
                SizedBox(height: 20),
                _buildMetricsRow(context),
                SizedBox(height: 20),
                _buildTransactionList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm...',
                  prefixIcon: Icon(Icons.search, color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUpdateCard() {
    return Card(
      color: Color(0xFF002B1F), // Dark green color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.red, size: 10),
                    SizedBox(width: 8),
                    Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Feb 12th 2024',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Sales revenue increased ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '40%',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' in 1 week',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'See Statistics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Icon(Icons.arrow_right, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsRow(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            child: _buildMetricCard(
              'Net Income',
              '\$193.000',
              '+35%',
              'from last month',
              Color(0xFF00C853),
            ),
          ),
          SizedBox(width: 16),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            child: _buildMetricCard(
              'Total Return',
              '\$32.000',
              '-24%',
              'from last month',
              Color(0xFFD50000),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String percentage,
    String subtitle,
    Color changeColor,
  ) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min, // Added to prevent overflow
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  // Changed from Flexible to Expanded to ensure the text takes available space
                  child: Text(title, style: TextStyle(fontSize: 16)),
                ),
                Icon(Icons.more_horiz, color: Colors.black),
              ],
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  changeColor == Color(0xFF00C853)
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: changeColor,
                  size: 16,
                ),
                SizedBox(width: 4),
                Expanded(
                  // Changed from Flexible to Expanded to ensure the text takes available space
                  child: Row(
                    children: [
                      Text(
                        percentage,
                        style: TextStyle(fontSize: 14, color: changeColor),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          subtitle,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          overflow:
                              TextOverflow.ellipsis, // Added to handle overflow
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Giao hàng',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildTransactionItem(
          'Tinek Detstar T-Shirt',
          'Jul 12th 2024',
          'Completed',
          Icons.check_circle,
          Colors.green,
        ),
        _buildTransactionItem(
          'Playstation 5',
          'Jul 12th 2024',
          'Pending',
          Icons.videogame_asset,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    String title,
    String date,
    String status,
    IconData icon,
    Color iconColor,
  ) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(status),
    );
  }
}
