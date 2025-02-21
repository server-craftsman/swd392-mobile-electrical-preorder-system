import 'package:flutter/material.dart';

class AdminOrdersPage extends StatefulWidget {
  @override
  _AdminOrdersPageState createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        // title: Text('Thống kê đơn hàng'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doanh thu',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildGraphBar('Điện thoại', Colors.grey, 50),
                  _buildGraphBar(
                    'Máy tính bảng',
                    Colors.red,
                    100,
                    highlight: true,
                  ),
                  _buildGraphBar('Máy tính', Colors.grey, 70),
                  _buildGraphBar('Phụ kiện', Colors.grey, 60),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Trạng thái đơn hàng',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusCard(
                  'Tổng đơn hàng',
                  2458,
                  Colors.red,
                  Icons.receipt,
                ),
                _buildStatusCard(
                  'Đang giao hàng',
                  356,
                  Colors.orange,
                  Icons.card_giftcard,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusCard(
                  'Đã giao hàng',
                  792,
                  Colors.blue,
                  Icons.local_shipping,
                ),
                _buildStatusCard(
                  'Đã giao hàng',
                  1300,
                  Colors.green,
                  Icons.check_circle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, int count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Icon(icon, color: color),
              ],
            ),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphBar(
    String label,
    Color color,
    double height, {
    bool highlight = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
