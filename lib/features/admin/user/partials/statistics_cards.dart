import 'package:flutter/material.dart';

class StatisticsCards extends StatelessWidget {
  const StatisticsCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
