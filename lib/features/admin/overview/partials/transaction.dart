import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_electrical_preorder_system/core/network/order/res/index.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';
import './constants.dart';
import 'package:mobile_electrical_preorder_system/features/admin/order/partials/order_details.dart';
import 'package:mobile_electrical_preorder_system/features/admin/order/index.dart';

class OrderCardWidget extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;

  const OrderCardWidget({Key? key, required this.order, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Status handling
    Color statusColor;
    String statusText;

    switch (order.status) {
      case 'PENDING':
        statusColor = DashboardColors.pending;
        statusText = 'Chờ xác nhận';
        break;
      case 'CONFIRMED':
        statusColor = DashboardColors.confirmed;
        statusText = 'Đã xác nhận';
        break;
      case 'SHIPPED':
        statusColor = DashboardColors.shipped;
        statusText = 'Đã giao hàng';
        break;
      case 'DELIVERED':
        statusColor = DashboardColors.delivered;
        statusText = 'Đã giao hàng';
        break;
      case 'CANCELLED':
        statusColor = DashboardColors.cancelled;
        statusText = 'Đã hủy';
        break;
      default:
        statusColor = Colors.grey;
        statusText = order.status;
    }

    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header with ID and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Order ID with # icon
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '#',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đơn hàng #${order.id.substring(0, 8)}...',
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          DateFormat(
                            'MMM dd, yyyy • hh:mm a',
                          ).format(order.createdAt),
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Status badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),

            // Product information
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product icon/image
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 10),

                // Product name and quantity
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.campaign.product.name,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        '${order.quantity} x ${currencyFormatter.format(order.totalAmount / order.quantity)}',
                        style: GoogleFonts.montserrat(
                          color: Colors.black54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                // Total price
                Text(
                  '${currencyFormatter.format(order.totalAmount)}',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Customer information and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Customer initial and name
                Row(
                  children: [
                    // Customer initial
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          order.user.fullname.isNotEmpty
                              ? order.user.fullname[0].toUpperCase()
                              : 'U',
                          style: GoogleFonts.montserrat(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),

                    // Customer name
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        'Khách hàng: ${order.user.fullname}',
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // View button
                InkWell(
                  onTap:
                      onTap ??
                      () {
                        // Navigate to order details page when tapping on the order card
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => OrderDetailsPage(order: order),
                          ),
                        );
                      },
                  child: Row(
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 14,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Xem',
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
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
}

class RecentOrdersWidget extends StatelessWidget {
  final List<Order> orders;
  final bool isLoading;

  const RecentOrdersWidget({
    Key? key,
    required this.orders,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title with document icon
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.description_outlined,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Đơn hàng gần đây',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Content
        if (isLoading)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          )
        else if (orders.isEmpty)
          Container(
            padding: const EdgeInsets.all(40.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 48,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Không có đơn hàng nào',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Đơn hàng sẽ xuất hiện ở đây khi khách hàng đặt hàng',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children:
                orders
                    .map(
                      (order) => OrderCardWidget(
                        order: order,
                        onTap: () {
                          // Navigate to order details page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => OrderDetailsPage(order: order),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
          ),
      ],
    );
  }
}
