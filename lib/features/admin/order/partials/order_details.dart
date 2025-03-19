import 'package:flutter/material.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  // Sample product data - in a real app, this would come from a database or API
  late List<Map<String, dynamic>> products;

  @override
  void initState() {
    super.initState();
    // Initialize with sample products based on the order
    products = [
      {
        'id': 'PRD-001',
        'name': 'Tủ lạnh Samsung',
        'price': '1.200.000đ',
        'quantity': 1,
        'image': 'assets/images/fridge.jpg',
      },
      {
        'id': 'PRD-002',
        'name': 'Máy giặt LG',
        'price': '800.000đ',
        'quantity': 1,
        'image': 'assets/images/washing_machine.jpg',
      },
      {
        'id': 'PRD-003',
        'name': 'Lò vi sóng Panasonic',
        'price': '500.000đ',
        'quantity': widget.order['items'] > 2 ? 1 : 0,
        'image': 'assets/images/microwave.jpg',
      },
    ];

    // Filter out products with quantity 0
    products = products.where((product) => product['quantity'] > 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Determine status color and icon
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (widget.order['status']) {
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID and Status
                Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mã đơn hàng:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              widget.order['id'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Trạng thái:',
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
                                border: Border.all(
                                  color: statusColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    statusIcon,
                                    size: 16,
                                    color: statusColor,
                                  ),
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
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Customer Information
                Text(
                  'Thông tin khách hàng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          Icons.person,
                          'Tên khách hàng',
                          widget.order['customer'],
                        ),
                        Divider(height: 24),
                        _buildInfoRow(
                          Icons.phone,
                          'Số điện thoại',
                          '0987654321',
                        ),
                        Divider(height: 24),
                        _buildInfoRow(
                          Icons.location_on,
                          'Địa chỉ',
                          '123 Đường ABC, Quận XYZ, TP. Hồ Chí Minh',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Order Information
                Text(
                  'Thông tin đơn hàng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          Icons.calendar_today,
                          'Ngày đặt hàng',
                          widget.order['date'],
                        ),
                        Divider(height: 24),
                        _buildInfoRow(
                          Icons.payment,
                          'Phương thức thanh toán',
                          'Thanh toán khi nhận hàng (COD)',
                        ),
                        Divider(height: 24),
                        _buildInfoRow(
                          Icons.local_shipping,
                          'Phương thức vận chuyển',
                          'Giao hàng tiêu chuẩn',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Product List
                Text(
                  'Danh sách sản phẩm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        for (var i = 0; i < products.length; i++) ...[
                          _buildProductItem(products[i]),
                          if (i < products.length - 1) Divider(height: 24),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Order Summary
                Text(
                  'Tổng kết đơn hàng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tổng tiền hàng'),
                            Text('2.300.000đ'),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('Phí vận chuyển'), Text('200.000đ')],
                        ),
                        Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tổng thanh toán',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              widget.order['amount'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Update order status logic
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Cập nhật trạng thái',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey, fontSize: 14)),
              SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(Icons.electrical_services, color: Colors.grey),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product['name'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                'Số lượng: ${product['quantity']}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                product['price'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
