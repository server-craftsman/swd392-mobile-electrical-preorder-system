import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManagerOrdersPage extends StatefulWidget {
  const ManagerOrdersPage({Key? key}) : super(key: key);

  @override
  State<ManagerOrdersPage> createState() => _ManagerOrdersPageState();
}

class _ManagerOrdersPageState extends State<ManagerOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> orders = [
    {
      'id': 'PO001',
      'customer': 'Phạm Thị Kiều Thắm',
      'date': '09-03-2025',
      'status': 'Đang xử lý',
      'total': '\60.000.000đ',
      'items': [
        {'name': 'Macbook Pro', 'quantity': 1, 'price': '\30.000.000đ'},
        {'name': 'Macbook Air', 'quantity': 1, 'price': '\30.000.000đ'},
      ],
      'address': 'Buôn Mê Thuộc, Đắk Lắk',
      'phone': '123456789',
    },
    {
      'id': 'PO002',
      'customer': 'Thắm Nhỏ Baby',
      'date': '08-03-2025',
      'status': 'Đã xác nhận',
      'total': '\60.000.000đ',
      'items': [
        {'name': 'Hoa hồng', 'quantity': 1, 'price': '\30.000.000đ'},
        {'name': 'Nước hoa', 'quantity': 1, 'price': '\30.000.000đ'},
      ],
      'address': 'Hà Nội',
      'phone': '123456789',
    },
    {
      'id': 'PO003',
      'customer': 'Phạm Thắm',
      'date': '',
      'status': 'Đã hoàn thành',
      'total': '\30.000.000đ',
      'items': [
        {'name': 'Ipad Pro', 'quantity': 1, 'price': '\30.000.000đ'},
      ],
      'address': 'Thái Thuỵ, Buôn Ma Thuột, Đắk Lắk',
      'phone': '123456789',
    },
    {
      'id': 'PO004',
      'customer': 'Nguyễn Đan Huy',
      'date': '07-03-2025',
      'status': 'Đã huỷ',
      'total': '\20.000.000 đ',
      'items': [
        {'name': 'iPhone 16e', 'quantity': 1, 'price': '\20.000.000đ'},
      ],
      'address': 'Tân Trụ, Long An',
      'phone': '123456789',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đang xử lý':
        return Colors.orange;
      case 'Đã xác nhận':
        return Colors.blue;
      case 'Đã hoàn thành':
        return Colors.green;
      case 'Đã huỷ':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getFilteredOrders(String status) {
    if (status == 'All') {
      return orders
          .where(
            (order) =>
                order['id'].toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                order['customer'].toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }
    return orders
        .where(
          (order) =>
              order['status'] == status &&
              (order['id'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  order['customer'].toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  )),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Quản lý đơn hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          indicatorWeight: 2.0,
          unselectedLabelColor: Colors.white.withOpacity(0.5),
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          isScrollable: true,
          labelPadding: EdgeInsets.symmetric(horizontal: 3),
          tabs: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              child: Tab(text: 'Tất cả'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Tab(text: 'Chờ xác nhận'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Tab(text: 'Đã xác nhận'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Tab(text: 'Hoàn thành'),
            ),
          ],
        ),
        actions: [IconButton(icon: Icon(Icons.filter_list), onPressed: () {})],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo mã đơn hoặc tên khách hàng',
                prefixIcon: Icon(Icons.search, color: Color(0xFF1A237E)),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                        : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList('All'),
                _buildOrderList('Đang xử lý'),
                _buildOrderList('Đã xác nhận'),
                _buildOrderList('Đã hoàn thành'),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color(0xFF1A237E),
      //   child: Icon(Icons.refresh),
      //   onPressed: () {
      //     setState(() {
      //       // Refresh data
      //     });
      //   },
      // ),
    );
  }

  Widget _buildOrderList(String status) {
    final filteredOrders = _getFilteredOrders(status);

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Không có đơn hàng nào',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailsPage(order: order),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Đơn hàng #${order['id']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            order['status'],
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getStatusColor(order['status']),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          order['status'],
                          style: TextStyle(
                            color: _getStatusColor(order['status']),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8),
                      Text(
                        order['customer'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8),
                      Text(
                        order['date'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${order['items'].length} sản phẩm',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        order['total'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;

  OrderDetailsPage({required this.order});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Confirmed':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng #${order['id']}'),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trạng thái đơn hàng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            order['status'],
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getStatusColor(order['status']),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          order['status'],
                          style: TextStyle(
                            color: _getStatusColor(order['status']),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 32),
                  Text(
                    'Thông tin khách hàng',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.person_outline,
                    'Khách hàng',
                    order['customer'],
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.phone_outlined,
                    'Số điện thoại',
                    order['phone'],
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    'Địa chỉ',
                    order['address'],
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Ngày đặt hàng',
                    order['date'],
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),

            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Danh sách sản phẩm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ...List.generate(
                    order['items'].length,
                    (index) => _buildProductItem(order['items'][index], index),
                  ),
                  Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng tiền',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        order['total'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.check_circle_outline),
                      label: Text('Xác nhận đơn hàng'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 0, 0),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed:
                          order['status'] == 'Pending'
                              ? () {
                                // Handle confirm order
                                Navigator.pop(context);
                              }
                              : null,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.cancel_outlined),
                      label: Text('Hủy đơn hàng'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.red),
                        ),
                      ),
                      onPressed:
                          order['status'] != 'Delivered' &&
                                  order['status'] != 'Cancelled'
                              ? () {
                                // Handle cancel order
                                Navigator.pop(context);
                              }
                              : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 16, color: Colors.black87)),
          ],
        ),
      ],
    );
  }

  Widget _buildProductItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF1A237E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Số lượng: ${item['quantity']}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            item['price'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1A237E),
            ),
          ),
        ],
      ),
    );
  }
}
