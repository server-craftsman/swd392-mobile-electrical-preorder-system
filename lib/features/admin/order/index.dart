import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/network/order/order.network.dart';
import './partials/order_details.dart';
import 'package:mobile_electrical_preorder_system/core/network/order/res/index.dart';
import 'package:intl/intl.dart';

class AdminOrdersPage extends StatefulWidget {
  @override
  _AdminOrdersPageState createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<Order> _orders = [];
  List<Order> _filteredOrders = [];
  bool _isLoading = true;
  int _totalOrders = 0;
  int _currentPage = 0;
  int _totalPages = 0;
  double _totalAmount = 0;
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final OrderNetwork _orderNetwork = OrderNetwork();

  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  // Define order status constants to match API values
  static const String STATUS_ALL = 'all';
  static const String STATUS_PENDING = 'PENDING';
  static const String STATUS_CONFIRMED = 'CONFIRMED';
  static const String STATUS_SHIPPED = 'SHIPPED';
  static const String STATUS_DELIVERED = 'DELIVERED';
  static const String STATUS_CANCELLED = 'CANCELLED';

  static const Color primaryColor = Color(0xFF1E88E5); // Blue
  static const Color accentColor = Color(0xFF1E88E5); //  Blue strong
  static const Color backgroundColor = Color(0xFFF5F7FA); // Light gray
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF263238); // Dark blue-gray
  static const Color textSecondaryColor = Color(0xFF78909C); // Gray

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _fetchOrders();

    // Add listener to search controller
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterOrders();
    });
  }

  void _filterOrders() {
    setState(() {
      _filteredOrders =
          _orders.where((order) {
            return order.user.fullname.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                order.id.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filteredOrders = _orders;
      }
    });
  }

  Future<void> _fetchOrders() async {
    try {
      if (!mounted) return;

      setState(() {
        _isLoading = true;
      });

      final result = await _orderNetwork.getOrderList();

      if (!mounted) return;

      setState(() {
        _orders = result['orders'];
        if (result['totalAmount'] != null) {
          _totalAmount =
              result['totalAmount'] is double
                  ? result['totalAmount']
                  : (result['totalAmount'] as num).toDouble();
        }
        _totalPages = result['totalPages'] ?? 0;
        _totalOrders = result['totalElements'] ?? 0;
        _currentPage = result['currentPage'] ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching orders: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load orders: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
              SizedBox(height: 20),
              Text(
                'Đang tải đơn hàng...',
                style: TextStyle(
                  color: textPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm đơn hàng...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  autofocus: true,
                )
                : Text(
                  'Quản lý đơn hàng',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
        elevation: 0,
        backgroundColor: Color(0xFF1A237E),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 20),
          onPressed: () {
            if (_isSearching) {
              _toggleSearch();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchOrders,
            color: Colors.white,
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            height: 60,
            child: TabBar(
              controller: _tabController!,
              tabs: [
                Tab(child: Text('Tất cả')),
                Tab(child: Text('Chờ xác nhận')),
                Tab(child: Text('Đã xác nhận')),
                Tab(child: Text('Đang giao')),
                Tab(child: Text('Đã giao')),
                Tab(child: Text('Đã hủy')),
              ],
              indicatorColor: accentColor,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundColor, Color(0xFFEDF2F7)],
          ),
        ),
        child: Column(
          children: [
            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController!,
                children: [
                  _buildOrderList(STATUS_ALL),
                  _buildOrderList(STATUS_PENDING),
                  _buildOrderList(STATUS_CONFIRMED),
                  _buildOrderList(STATUS_SHIPPED),
                  _buildOrderList(STATUS_DELIVERED),
                  _buildOrderList(STATUS_CANCELLED),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build order list based on status - Updated to match API status values
  Widget _buildOrderList(String status) {
    final ordersToDisplay = _searchQuery.isEmpty ? _orders : _filteredOrders;
    final filteredOrders =
        status == STATUS_ALL
            ? ordersToDisplay
            : ordersToDisplay.where((order) => order.status == status).toList();

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: textSecondaryColor.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'Không có đơn hàng nào',
              style: TextStyle(
                fontSize: 18,
                color: textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tất cả đơn hàng sẽ được hiển thị tại đây',
              style: TextStyle(
                fontSize: 14,
                color: textSecondaryColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        final order = filteredOrders[index];

        // Determine status color and icon
        Color statusColor;
        IconData statusIcon;
        String statusText;

        switch (order.status) {
          case STATUS_PENDING:
            statusColor = Color(0xFFF39C12); // Orange
            statusIcon = Icons.hourglass_empty;
            statusText = 'Chờ xác nhận';
            break;
          case STATUS_CONFIRMED:
            statusColor = Color(0xFF3498DB); // Blue
            statusIcon = Icons.check_circle_outline;
            statusText = 'Đã xác nhận';
            break;
          case STATUS_SHIPPED:
            statusColor = Color(0xFF9B59B6); // Purple
            statusIcon = Icons.local_shipping;
            statusText = 'Đang giao';
            break;
          case STATUS_DELIVERED:
            statusColor = Color(0xFF2ECC71); // Green
            statusIcon = Icons.check_circle;
            statusText = 'Đã giao';
            break;
          case STATUS_CANCELLED:
            statusColor = Color(0xFFE74C3C); // Red
            statusIcon = Icons.cancel;
            statusText = 'Đã hủy';
            break;
          default:
            statusColor = textSecondaryColor;
            statusIcon = Icons.help_outline;
            statusText = 'Không xác định';
        }

        return Card(
          margin: EdgeInsets.only(bottom: 16),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                // Status bar at top
                Container(
                  color: statusColor.withOpacity(0.1),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      SizedBox(width: 6),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      Text(
                        DateFormat('dd/MM/yyyy').format(order.createdAt),
                        style: TextStyle(
                          color: textSecondaryColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main content
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order ID and quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.qr_code,
                                size: 16,
                                color: Color(0xFF1A237E),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'ID: ${order.id.substring(0, min(8, order.id.length))}...',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF1A237E).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 14,
                                  color: Color(0xFF1A237E),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${order.quantity} sản phẩm',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Customer info
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Color(0xFF1A237E).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              size: 20,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.user.fullname,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: textPrimaryColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  order.user.email,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textSecondaryColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Product info
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.devices_other,
                              color: textSecondaryColor,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.campaign.product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: textPrimaryColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  order.campaign.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Divider
                      Divider(height: 1, color: Colors.grey.withOpacity(0.2)),

                      SizedBox(height: 16),

                      // Total amount and actions
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tổng tiền:',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: textSecondaryColor,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                currencyFormatter.format(order.totalAmount),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () async {
                              // Use await to get the result from OrderDetailsPage
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          OrderDetailsPage(order: order),
                                ),
                              );

                              // Check if we got a deletion result back
                              if (result is Map && result['deleted'] == true) {
                                // Show success message in this screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      result['message'] ??
                                          'Đơn hàng đã được xóa thành công',
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );

                                // Refresh the order list
                                _fetchOrders();
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Color(0xFF1A237E),
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: Color(0xFF1A237E).withOpacity(0.3),
                                ),
                              ),
                            ),
                            child: Text('Chi tiết'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Update status dialog to match API status values
  void _showUpdateStatusDialog(Order order) {
    String selectedStatus = order.status;

    // Define available next statuses based on current status
    List<String> availableStatuses = [];

    switch (order.status) {
      case STATUS_PENDING:
        availableStatuses = [
          STATUS_PENDING,
          STATUS_CONFIRMED,
          STATUS_CANCELLED,
        ];
        break;
      case STATUS_CONFIRMED:
        availableStatuses = [
          STATUS_CONFIRMED,
          STATUS_SHIPPED,
          STATUS_CANCELLED,
        ];
        break;
      case STATUS_SHIPPED:
        availableStatuses = [
          STATUS_SHIPPED,
          STATUS_DELIVERED,
          STATUS_CANCELLED,
        ];
        break;
      case STATUS_DELIVERED:
        availableStatuses = [STATUS_DELIVERED]; // Cannot change once delivered
        break;
      default:
        availableStatuses = [
          STATUS_PENDING,
          STATUS_CONFIRMED,
          STATUS_SHIPPED,
          STATUS_DELIVERED,
          STATUS_CANCELLED,
        ];
    }

    // Define colors for each status
    Map<String, Color> statusColors = {
      STATUS_PENDING: Color(0xFFF39C12),
      STATUS_CONFIRMED: Color(0xFF3498DB),
      STATUS_SHIPPED: Color(0xFF9B59B6),
      STATUS_DELIVERED: Color(0xFF2ECC71),
      STATUS_CANCELLED: Color(0xFFE74C3C),
    };

    // Define icons for each status
    Map<String, IconData> statusIcons = {
      STATUS_PENDING: Icons.hourglass_empty,
      STATUS_CONFIRMED: Icons.check_circle_outline,
      STATUS_SHIPPED: Icons.local_shipping,
      STATUS_DELIVERED: Icons.check_circle,
      STATUS_CANCELLED: Icons.cancel,
    };

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Cập nhật trạng thái đơn hàng',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        availableStatuses.map((status) {
                          return RadioListTile<String>(
                            title: Row(
                              children: [
                                Icon(
                                  statusIcons[status],
                                  size: 18,
                                  color: statusColors[status],
                                ),
                                SizedBox(width: 8),
                                Text(
                                  _getStatusText(status),
                                  style: TextStyle(
                                    fontWeight:
                                        selectedStatus == status
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    color:
                                        selectedStatus == status
                                            ? statusColors[status]
                                            : textPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                            value: status,
                            groupValue: selectedStatus,
                            activeColor: statusColors[status],
                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value!;
                              });
                            },
                          );
                        }).toList(),
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: textSecondaryColor,
                ),
                child: Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Here you would call an API to update the order status
                  // For now, just show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 12),
                          Text('Đã cập nhật trạng thái đơn hàng'),
                        ],
                      ),
                      backgroundColor: accentColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  // Refresh the order list to show the updated status
                  _fetchOrders();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Cập nhật'),
              ),
            ],
          ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case STATUS_PENDING:
        return 'Chờ xác nhận';
      case STATUS_CONFIRMED:
        return 'Đã xác nhận';
      case STATUS_SHIPPED:
        return 'Đang giao';
      case STATUS_DELIVERED:
        return 'Đã giao';
      case STATUS_CANCELLED:
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }
}

// Helper function
int min(int a, int b) => a < b ? a : b;
