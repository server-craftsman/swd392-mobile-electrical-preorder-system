import 'package:flutter/material.dart';
import './status_card.dart';

/// This class is now a wrapper around OrderStatusOverviewWidget
/// to maintain backward compatibility while using the new UI design
class OrderStatisticsWidget extends StatelessWidget {
  final Map<String, int> orderStatusCounts;
  final bool isLoading;

  const OrderStatisticsWidget({
    Key? key,
    required this.orderStatusCounts,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ),
      );
    }

    // Use the new OrderStatusOverviewWidget for consistent UI
    return OrderStatusOverviewWidget(orderStatusCounts: orderStatusCounts);
  }
}
