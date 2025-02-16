import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tổng quan',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Summary of key metrics
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Set background to white
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildMetricCard('Đơn hàng mới', '345'),
                      SizedBox(width: 10),
                      _buildMetricCard('Khách hàng mới', '120'),
                      SizedBox(width: 10),
                      _buildMetricCard('Doanh thu', '12,345 VNĐ'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Interactive line chart
              Card(
                color: Colors.white, // Set card background to white
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Biểu đồ doanh thu', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Container(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: _createSampleData(),
                                isCurved: true,
                                barWidth: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Recent activity log
              Card(
                color: Colors.white, // Set card background to white
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hoạt động gần đây', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.shopping_cart),
                        title: Text('Đơn hàng #1234 đã được đặt'),
                        subtitle: Text('5 phút trước'),
                      ),
                      ListTile(
                        leading: Icon(Icons.person_add),
                        title: Text('Khách hàng mới: Phạm Thị Thắm'),
                        subtitle: Text('10 phút trước'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Existing card for tasks and events
              Card(
                color: Colors.white, // Set card background to white
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quản lí chiến dịch',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.campaign),
                        title: Text('Chiến dịch quảng cáo mùa hè'),
                        subtitle: Text('Ngày bắt đầu: 16/02/2025'),
                        trailing: Chip(label: Text('Active')),
                      ),
                      ListTile(
                        leading: Icon(Icons.campaign),
                        title: Text('Chiến dịch giảm giá cuối năm'),
                        subtitle: Text('Ngày bắt đầu: 16/02/2025'),
                        trailing: Chip(label: Text('Active')),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build metric cards
  Widget _buildMetricCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Sample data for the line chart
  List<FlSpot> _createSampleData() {
    return [FlSpot(0, 5), FlSpot(1, 25), FlSpot(2, 100), FlSpot(3, 75)];
  }
}
