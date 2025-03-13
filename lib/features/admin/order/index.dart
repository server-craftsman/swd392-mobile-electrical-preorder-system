import 'package:flutter/material.dart';
import './partials/order_details.dart';

class AdminOrdersPage extends StatefulWidget {
  @override
  _AdminOrdersPageState createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        title: Text('Quản lý đơn hàng', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order List Section
              Text(
                'Danh sách đơn hàng',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Tab Bar
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController!,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  labelPadding: EdgeInsets.symmetric(horizontal: 4),
                  indicatorPadding: EdgeInsets.zero,
                  isScrollable: false,
                  tabs: [
                    Tab(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text('Tất cả'),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text('Đang giao'),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text('Đã giao'),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text('Hoàn thành'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Tab Bar View
              Expanded(
                child: TabBarView(
                  controller: _tabController!,
                  children: [
                    _buildOrderList('all'),
                    _buildOrderList('shipping'),
                    _buildOrderList('delivered'),
                    _buildOrderList('completed'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build order list based on status
  Widget _buildOrderList(String status) {
    // Sample order data - in a real app, this would come from a database or API
    final List<Map<String, dynamic>> orders = [
      {
        'id': 'ORD-001',
        'customer': 'Phạm Thị Kiều Thắm',
        'date': '20/01/2025',
        'amount': '2.500.000đ',
        'status': 'shipping',
        'items': 3,
      },
      {
        'id': 'ORD-002',
        'customer': 'Thắm nhỏ baby',
        'date': '19/02/2025',
        'amount': '1.800.000đ',
        'status': 'delivered',
        'items': 2,
      },
      {
        'id': 'ORD-003',
        'customer': 'Nguyễn Đan Huy',
        'date': '18/02/2025',
        'amount': '3.200.000đ',
        'status': 'completed',
        'items': 4,
      },
      {
        'id': 'ORD-004',
        'customer': 'Phạm Thắm',
        'date': '17/01/2025',
        'amount': '950.000đ',
        'status': 'shipping',
        'items': 1,
      },
      {
        'id': 'ORD-005',
        'customer': 'Nguyễn Đan Huy',
        'date': '16/02/2025',
        'amount': '4.100.000đ',
        'status': 'completed',
        'items': 5,
      },
    ];

    // Filter orders based on status
    final filteredOrders =
        status == 'all'
            ? orders
            : orders.where((order) => order['status'] == status).toList();

    if (filteredOrders.isEmpty) {
      return Center(
        child: Text(
          'Không có đơn hàng nào',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      padding: EdgeInsets.only(bottom: 16),
      itemBuilder: (context, index) {
        final order = filteredOrders[index];

        // Determine status color and icon
        Color statusColor;
        IconData statusIcon;
        String statusText;

        switch (order['status']) {
          case 'shipping':
            statusColor = Colors.orange;
            statusIcon = Icons.local_shipping;
            statusText = 'Đang giao';
            break;
          case 'delivered':
            statusColor = Colors.blue;
            statusIcon = Icons.inventory;
            statusText = 'Đã giao';
            break;
          case 'completed':
            statusColor = Colors.green;
            statusIcon = Icons.check_circle;
            statusText = 'Hoàn thành';
            break;
          default:
            statusColor = Colors.grey;
            statusIcon = Icons.help_outline;
            statusText = 'Không xác định';
        }

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['id'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 16, color: statusColor),
                          SizedBox(width: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      order['customer'],
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      order['date'],
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    Spacer(),
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${order['items']} sản phẩm',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng tiền:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      order['amount'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Update the TextButton onPressed callback in the _buildOrderList method
                    TextButton(
                      onPressed: () {
                        // Navigate to order details page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => OrderDetailsPage(order: order),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.indigo,
                        padding: EdgeInsets.zero,
                        minimumSize: Size(80, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text('Xem chi tiết'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Update order status
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Text('Cập nhật'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
