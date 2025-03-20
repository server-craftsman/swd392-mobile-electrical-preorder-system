import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_electrical_preorder_system/core/network/order/order.network.dart';
import 'package:mobile_electrical_preorder_system/core/network/order/res/index.dart';

// Import partials with consistent naming
import './partials/dashboard.dart';
import './partials/search.dart';
import './partials/card_state_less.dart';
import './partials/transaction.dart';
import './partials/constants.dart';
import './partials/status_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, int> _orderStatusCounts = {
    'PENDING': 0,
    'CONFIRMED': 0,
    'SHIPPED': 0,
    'DELIVERED': 0,
    'CANCELLED': 0,
  };

  bool _isLoading = false;
  List<Order> _recentOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrderData();
  }

  Future<void> _fetchOrderData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final orderList = await OrderNetwork().getOrderList(
        size: 50,
      ); // Fetch more to ensure we have enough for statistics
      final orders = orderList['orders'] as List<Order>;

      // Reset counts
      _orderStatusCounts.updateAll((key, value) => 0);

      // Count orders by status
      for (var order in orders) {
        if (_orderStatusCounts.containsKey(order.status)) {
          _orderStatusCounts[order.status] =
              _orderStatusCounts[order.status]! + 1;
        }
      }

      // Get recent orders (up to 5)
      _recentOrders = orders.take(5).toList();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching order data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardColors.background,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: DashboardColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchOrderData,
            tooltip: 'Refresh data',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Gradient header
            Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    DashboardColors.primary,
                    DashboardColors.primaryLight,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: SearchBarWidget(),
              ),
            ),

            // Scrollable content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchOrderData,
                color: DashboardColors.secondary,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const UpdateCardWidget(),
                        const SizedBox(height: 24),
                        const OverviewPage(),
                        const SizedBox(height: 24),

                        // Order Statistics Section - using new widget
                        _isLoading
                            ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    DashboardColors.secondary,
                                  ),
                                ),
                              ),
                            )
                            : OrderStatusOverviewWidget(
                              orderStatusCounts: _orderStatusCounts,
                            ),

                        const SizedBox(height: 24),

                        // Recent Orders Section
                        RecentOrdersWidget(
                          orders: _recentOrders,
                          isLoading: _isLoading,
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
