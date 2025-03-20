import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './constants.dart';

class OrderStatusCardWidget extends StatelessWidget {
  final String status;
  final String statusText;
  final IconData icon;
  final Color color;
  final int count;

  const OrderStatusCardWidget({
    Key? key,
    required this.status,
    required this.statusText,
    required this.icon,
    required this.color,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(child: Icon(icon, color: color, size: 16)),
            ),
            SizedBox(width: 10),
            // Status text and count
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    statusText,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    count.toString(),
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
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
}

class OrderStatusOverviewWidget extends StatelessWidget {
  final Map<String, int> orderStatusCounts;

  const OrderStatusOverviewWidget({Key? key, required this.orderStatusCounts})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.analytics_outlined,
                    color: Colors.orange,
                    size: 18,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Trạng thái đơn hàng',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),

        // Status cards grid
        GridView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          children: [
            OrderStatusCardWidget(
              status: 'PENDING',
              statusText: 'Chờ xác nhận',
              icon: Icons.pending_actions,
              color: DashboardColors.pending,
              count: orderStatusCounts['PENDING'] ?? 0,
            ),
            OrderStatusCardWidget(
              status: 'CONFIRMED',
              statusText: 'Đã xác nhận',
              icon: Icons.check_circle_outline,
              color: DashboardColors.confirmed,
              count: orderStatusCounts['CONFIRMED'] ?? 0,
            ),
            OrderStatusCardWidget(
              status: 'SHIPPED',
              statusText: 'Đang giao hàng',
              icon: Icons.local_shipping_outlined,
              color: DashboardColors.shipped,
              count: orderStatusCounts['SHIPPED'] ?? 0,
            ),
            OrderStatusCardWidget(
              status: 'DELIVERED',
              statusText: 'Đã giao hàng',
              icon: Icons.inventory_2_outlined,
              color: DashboardColors.delivered,
              count: orderStatusCounts['DELIVERED'] ?? 0,
            ),
          ],
        ),
        SizedBox(height: 12),

        // Cancelled status card
        OrderStatusCardWidget(
          status: 'CANCELLED',
          statusText: 'Đã hủy',
          icon: Icons.cancel_outlined,
          color: DashboardColors.cancelled,
          count: orderStatusCounts['CANCELLED'] ?? 0,
        ),
      ],
    );
  }
}
