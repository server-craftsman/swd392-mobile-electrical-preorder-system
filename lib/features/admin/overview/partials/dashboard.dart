import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_electrical_preorder_system/core/network/campaign/campaign.network.dart';
// import 'package:mobile_electrical_preorder_system/core/network/order/order.network.dart';
// import 'package:mobile_electrical_preorder_system/core/network/order/res/index.dart';
import 'package:mobile_electrical_preorder_system/core/network/product/product_network.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  late Future<int> _productCountFuture;
  late Future<int> _activeCampaignCountFuture;
  late Future<int> _completedCampaignCountFuture;
  late Future<int> _canceledCampaignCountFuture;

  // Order statistics
  // late Future<int> _pendingOrderCountFuture;
  // late Future<int> _completedOrderCountFuture;
  // late Future<int> _canceledOrderCountFuture;
  // late Future<double> _totalOrderAmountFuture;
  // late Future<List<Order>> _recentOrdersFuture;

  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  void initState() {
    super.initState();
    _productCountFuture = ProductNetwork.countProduct();
    _loadCampaignStatistics();
    _loadOrderStatistics();
  }

  void _loadCampaignStatistics() {
    _activeCampaignCountFuture = _getCampaignCountByStatus('ACTIVE');
    _completedCampaignCountFuture = _getCampaignCountByStatus('COMPLETED');
    _canceledCampaignCountFuture = _getCampaignCountByStatus('CANCELLED');
  }

  void _loadOrderStatistics() {
    // Wrap each future in a try-catch to prevent one failure from affecting others
    // _pendingOrderCountFuture = _getOrderCountByStatus('PENDING');
    // _completedOrderCountFuture = _getOrderCountByStatus('COMPLETED');
    // _canceledOrderCountFuture = _getOrderCountByStatus('CANCELED');
    // _totalOrderAmountFuture = _getTotalOrderAmount();
    // _recentOrdersFuture = _getRecentOrders();
  }

  Future<int> _getCampaignCountByStatus(String status) async {
    try {
      final response = await CampaignNetwork.getCampaignList(status: status);
      return response.data.totalElements;
    } catch (e) {
      print('Error fetching $status campaigns: $e');
      return 0;
    }
  }

  // Future<int> _getOrderCountByStatus(String status) async {
  //   try {
  //     return await OrderNetwork.countOrdersByStatus(status);
  //   } catch (e) {
  //     debugPrint('Error fetching $status orders: $e');
  //     return 0;
  //   }
  // }

  // Future<double> _getTotalOrderAmount() async {
  //   try {
  //     return await OrderNetwork.getTotalOrderAmount();
  //   } catch (e) {
  //     debugPrint('Error fetching total order amount: $e');
  //     return 0;
  //   }
  // }

  // Future<List<Order>> _getRecentOrders() async {
  //   try {
  //     return await OrderNetwork.getRecentOrders();
  //   } catch (e) {
  //     debugPrint('Error fetching recent orders: $e');
  //     return [];
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Revenue Card - Displayed prominently at the top
          // _buildTotalRevenueCard(),
          const SizedBox(height: 20),

          // Product Statistics Section
          const SectionHeader(
            title: 'Thống kê sản phẩm',
            icon: Icons.inventory_2,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_buildLuxuryProductCount()],
          ),

          const SizedBox(height: 30),

          // Order Statistics Section
          const SectionHeader(
            title: 'Thống kê đơn hàng',
            icon: Icons.shopping_cart,
          ),
          const SizedBox(height: 15),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     _buildOrderCard(
          //       title: 'Đơn hàng đang xử lý',
          //       future: _pendingOrderCountFuture,
          //       color: Colors.blue,
          //       icon: Icons.pending_actions,
          //     ),
          //     _buildOrderCard(
          //       title: 'Đơn hàng đã xử lý',
          //       future: _completedOrderCountFuture,
          //       color: Colors.green,
          //       icon: Icons.check_circle,
          //     ),
          //   ],
          // ),
          const SizedBox(height: 20),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     _buildOrderCard(
          //       title: 'Đơn hàng bị hủy',
          //       future: _canceledOrderCountFuture,
          //       color: Colors.red,
          //       icon: Icons.cancel,
          //     ),
          //   ],
          // ),
          const SizedBox(height: 20),

          // Campaign Statistics Section
          const SectionHeader(
            title: 'Thống kê chiến dịch',
            icon: Icons.campaign,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCampaignCard(
                title: 'Chiến dịch đang hoạt động',
                future: _activeCampaignCountFuture,
                color: Colors.purple,
                icon: Icons.rocket_launch,
              ),
              _buildCampaignCard(
                title: 'Chiến dịch đã hoàn thành',
                future: _completedCampaignCountFuture,
                color: Colors.teal,
                icon: Icons.task_alt,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCampaignCard(
                title: 'Chiến dịch bị hủy',
                future: _canceledCampaignCountFuture,
                color: Colors.deepOrange,
                icon: Icons.cancel_presentation,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Recent Orders Section
          const SectionHeader(
            title: 'Đơn hàng gần đây',
            icon: Icons.receipt_long,
          ),
          const SizedBox(height: 15),
          // _buildRecentOrdersList(),
        ],
      ),
    );
  }

  // Widget _buildTotalRevenueCard() {
  //   return FutureBuilder<double>(
  //     future: _totalOrderAmountFuture,
  //     builder: (context, snapshot) {
  //       String displayAmount = '0 ₫';

  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         displayAmount = 'Đang tải...';
  //       } else if (snapshot.hasError) {
  //         displayAmount = 'Lỗi dữ liệu';
  //       } else if (snapshot.hasData) {
  //         displayAmount = currencyFormatter.format(snapshot.data);
  //       }

  //       return Center(
  //         child: Container(
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(12),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.amber.withOpacity(0.3),
  //                 blurRadius: 10,
  //                 offset: const Offset(0, 4),
  //               ),
  //             ],
  //             border: Border.all(color: Colors.amber[800]!, width: 2.0),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(20.0),
  //             child: Column(
  //               children: [
  //                 Text(
  //                   'Tổng doanh thu',
  //                   style: GoogleFonts.roboto(
  //                     fontSize: 18,
  //                     color: Colors.black87,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(
  //                       Icons.attach_money,
  //                       color: Colors.amber[800]!,
  //                       size: 36,
  //                     ),
  //                     const SizedBox(width: 8),
  //                     Text(
  //                       displayAmount,
  //                       style: GoogleFonts.montserrat(
  //                         fontSize: 32,
  //                         color: Colors.amber[800],
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildRecentOrdersList() {
  //   return FutureBuilder<List<Order>>(
  //     future: _recentOrdersFuture,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Container(
  //           height: 200,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(12),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.2),
  //                 blurRadius: 10,
  //                 offset: const Offset(0, 4),
  //               ),
  //             ],
  //           ),
  //           child: Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 CircularProgressIndicator(
  //                   valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
  //                 ),
  //                 SizedBox(height: 16),
  //                 Text(
  //                   'Đang tải đơn hàng gần đây...',
  //                   style: TextStyle(color: Colors.grey[600]),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }

  //       if (snapshot.hasError) {
  //         debugPrint('Error loading recent orders: ${snapshot.error}');
  //         return Container(
  //           height: 200,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(12),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.2),
  //                 blurRadius: 10,
  //                 offset: const Offset(0, 4),
  //               ),
  //             ],
  //           ),
  //           child: Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Icon(Icons.error_outline, color: Colors.red, size: 48),
  //                 SizedBox(height: 16),
  //                 Text(
  //                   'Không thể tải đơn hàng gần đây',
  //                   style: TextStyle(color: Colors.red),
  //                 ),
  //                 SizedBox(height: 8),
  //                 Text(
  //                   'Lỗi: ${snapshot.error}',
  //                   style: TextStyle(color: Colors.red[300], fontSize: 12),
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }

  //       final orders = snapshot.data ?? [];

  //       if (orders.isEmpty) {
  //         return Container(
  //           height: 200,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(12),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.2),
  //                 blurRadius: 10,
  //                 offset: const Offset(0, 4),
  //               ),
  //             ],
  //           ),
  //           child: Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Icon(Icons.receipt_long, color: Colors.grey, size: 48),
  //                 SizedBox(height: 16),
  //                 Text(
  //                   'Không có đơn hàng gần đây',
  //                   style: TextStyle(color: Colors.grey[600]),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }

  //       return Container(
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(12),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(0.2),
  //               blurRadius: 10,
  //               offset: const Offset(0, 4),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.receipt_long, color: Colors.indigo),
  //                   SizedBox(width: 8),
  //                   Text(
  //                     'Đơn hàng gần đây (${orders.length})',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 16,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Divider(height: 1),
  //             ListView.separated(
  //               shrinkWrap: true,
  //               physics: NeverScrollableScrollPhysics(),
  //               itemCount: orders.length,
  //               separatorBuilder: (context, index) => Divider(height: 1),
  //               itemBuilder: (context, index) {
  //                 final order = orders[index];

  //                 // Determine order status color and text
  //                 Color statusColor;
  //                 String statusText;

  //                 switch (order.status) {
  //                   case 'PENDING':
  //                     statusColor = Colors.blue;
  //                     statusText = 'Đang xử lý';
  //                     break;
  //                   case 'CONFIRMED':
  //                     statusColor = Colors.green;
  //                     statusText = 'Đã xác nhận';
  //                     break;
  //                   case 'SHIPPED':
  //                     statusColor = Colors.amber;
  //                     statusText = 'Đang giao';
  //                     break;
  //                   case 'DELIVERED':
  //                     statusColor = Colors.teal;
  //                     statusText = 'Đã giao';
  //                     break;
  //                   case 'CANCELLED':
  //                   case 'CANCELED':
  //                     statusColor = Colors.red;
  //                     statusText = 'Đã hủy';
  //                     break;
  //                   default:
  //                     statusColor = Colors.grey;
  //                     statusText = order.status;
  //                 }

  //                 return ListTile(
  //                   contentPadding: EdgeInsets.symmetric(
  //                     horizontal: 16,
  //                     vertical: 8,
  //                   ),
  //                   leading: CircleAvatar(
  //                     backgroundColor: statusColor.withOpacity(0.1),
  //                     child: Icon(Icons.shopping_bag, color: statusColor),
  //                   ),
  //                   title: Text(
  //                     order.campaign.product.name,
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                   subtitle: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       SizedBox(height: 4),
  //                       Text(
  //                         'Khách hàng: ${order.user.fullname}',
  //                         style: TextStyle(fontSize: 12),
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                       SizedBox(height: 4),
  //                       Text(
  //                         'Ngày đặt: ${DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt)}',
  //                         style: TextStyle(fontSize: 12),
  //                       ),
  //                     ],
  //                   ),
  //                   trailing: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.end,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         currencyFormatter.format(order.totalAmount),
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.amber[800],
  //                         ),
  //                       ),
  //                       SizedBox(height: 4),
  //                       Container(
  //                         padding: EdgeInsets.symmetric(
  //                           horizontal: 8,
  //                           vertical: 2,
  //                         ),
  //                         decoration: BoxDecoration(
  //                           color: statusColor.withOpacity(0.1),
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                         child: Text(
  //                           statusText,
  //                           style: TextStyle(
  //                             color: statusColor,
  //                             fontSize: 10,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Build order card with real data
  Widget _buildOrderCard({
    required String title,
    required Future<int> future,
    required Color color,
    required IconData icon,
  }) {
    return FutureBuilder<int>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard(title, color, icon);
        }

        if (snapshot.hasError) {
          return _buildErrorCard(title, color, icon, snapshot.error);
        }

        return DashboardCard(
          title: title,
          value: '${snapshot.data ?? 0}',
          color: color,
          icon: icon,
        );
      },
    );
  }

  // Build campaign card with real data
  Widget _buildCampaignCard({
    required String title,
    required Future<int> future,
    required Color color,
    required IconData icon,
  }) {
    return FutureBuilder<int>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard(title, color, icon);
        }

        if (snapshot.hasError) {
          return _buildErrorCard(title, color, icon, snapshot.error);
        }

        return DashboardCard(
          title: title,
          value: '${snapshot.data ?? 0}',
          color: color,
          icon: icon,
        );
      },
    );
  }

  // Loading state for card
  Widget _buildLoadingCard(String title, Color color, IconData icon) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color.withOpacity(0.5), size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Error state for card
  Widget _buildErrorCard(
    String title,
    Color color,
    IconData icon,
    Object? error,
  ) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.red.shade300, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Icon(Icons.error_outline, color: Colors.red.shade400, size: 24),
          ],
        ),
      ),
    );
  }

  // Replace the old _buildProductCount with this luxury version
  Widget _buildLuxuryProductCount() {
    return FutureBuilder<int>(
      future: _productCountFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade300),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Lỗi: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo.shade50, Colors.white],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.indigo.shade300, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2,
                      color: Colors.indigo.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sản phẩm',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.indigo.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${snapshot.data}',
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    color: Colors.indigo.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tổng số lượng',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionHeader({Key? key, required this.title, required this.icon})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(body: OverviewPage()),
      debugShowCheckedModeBanner: false,
    ),
  );
}
