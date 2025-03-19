import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/network/order/res/index.dart';
import 'package:intl/intl.dart';
import 'package:mobile_electrical_preorder_system/core/network/order/order.network.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;

  OrderDetailsPage({required this.order});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  final OrderNetwork _orderNetwork = OrderNetwork();
  bool _isDeleting = false;

  // Modern luxury color scheme
  static const Color primaryColor = Color(0xFF1A237E); // Deep brown
  static const Color accentColor = Color(0xFF7986CB); // Light indigo
  static const Color backgroundColor = Color(0xFFF8F9FA); // Soft white
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF37474F); // Dark blue-grey
  static const Color textSecondaryColor = Color(0xFF78909C); // Light blue-grey
  static const Color goldAccent = Color(0xFFFFD54F); // Amber
  static const Color dangerColor = Color(0xFFE57373); // Light red

  // IMPORTANT: Store scaffoldMessenger in initState
  late ScaffoldMessengerState _scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store reference to scaffold messenger
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  Widget build(BuildContext context) {
    // Determine status color and text
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (widget.order.status) {
      case 'PENDING':
        statusColor = Color(0xFFFFA726); // Orange
        statusIcon = Icons.hourglass_empty;
        statusText = 'Chờ xác nhận';
        break;
      case 'CONFIRMED':
        statusColor = Color(0xFF42A5F5); // Blue
        statusIcon = Icons.check_circle_outline;
        statusText = 'Đã xác nhận';
        break;
      case 'SHIPPED':
        statusColor = Color(0xFF7E57C2); // Purple
        statusIcon = Icons.local_shipping;
        statusText = 'Đang giao';
        break;
      case 'DELIVERED':
        statusColor = Color(0xFF66BB6A); // Green
        statusIcon = Icons.check_circle;
        statusText = 'Đã giao';
        break;
      case 'CANCELLED':
        statusColor = Color(0xFFEF5350); // Red
        statusIcon = Icons.cancel;
        statusText = 'Đã hủy';
        break;
      default:
        statusColor = textSecondaryColor;
        statusIcon = Icons.help_outline;
        statusText = 'Không xác định';
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero header section
                _buildHeroHeader(context, statusColor, statusText, statusIcon),

                // Content sections in a container
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order summary card
                      _buildOrderSummaryCard(),

                      // Section title - Customer info
                      _buildSectionTitle('Thông tin khách hàng'),

                      // Customer info card
                      _buildCustomerInfoCard(),

                      // Section title - Product
                      _buildSectionTitle('Thông tin sản phẩm'),

                      // Product card
                      _buildProductCard(),

                      // Section title - Campaign
                      _buildSectionTitle('Thông tin chiến dịch'),

                      // Campaign card
                      _buildCampaignCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // App bar with back button and delete action
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).padding.top + 56,
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                child: Row(
                  children: [
                    // Back button
                    _buildIconButton(
                      context,
                      Icons.arrow_back_ios_rounded,
                      () => Navigator.pop(context),
                    ),
                    Spacer(),
                    // Delete button
                    _buildIconButton(
                      context,
                      Icons.delete_outline_rounded,
                      () => _showDeleteConfirmDialog(context),
                      dangerColor,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Loading overlay
          if (_isDeleting)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: FloatingActionButton.extended(
          onPressed: () => _showDeleteConfirmDialog(context),
          backgroundColor: dangerColor,
          elevation: 4,
          icon: Icon(Icons.delete_rounded),
          label: Text(
            'Xóa đơn hàng',
            style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Hero header with status and curved design
  Widget _buildHeroHeader(
    BuildContext context,
    Color statusColor,
    String statusText,
    IconData statusIcon,
  ) {
    return Container(
      width: double.infinity,
      height: 280,
      child: Stack(
        children: [
          // Background design
          Positioned.fill(
            child: ClipPath(
              clipper: CurvedBottomClipper(),
              child: Container(
                color: primaryColor,
                child: Stack(
                  children: [
                    // Decorative elements
                    Positioned(
                      top: -50,
                      right: -20,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: -30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content overlay
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 100, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Chi tiết đơn hàng',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8),

                  // ID
                  Text(
                    'Mã đơn hàng: ${_truncateId(widget.order.id)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 24),

                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Order summary card with date and total amount
  Widget _buildOrderSummaryCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order date
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.calendar_today_rounded,
                      color: accentColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ngày đặt hàng',
                        style: TextStyle(
                          color: textSecondaryColor,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        DateFormat('dd/MM/yyyy').format(widget.order.createdAt),
                        style: TextStyle(
                          color: textPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Divider(height: 24, color: Colors.grey.withOpacity(0.2)),

              // Total amount
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: goldAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: goldAccent,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng giá trị đơn hàng',
                        style: TextStyle(
                          color: textSecondaryColor,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        currencyFormatter.format(widget.order.totalAmount),
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Customer information card
  Widget _buildCustomerInfoCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Avatar and name
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(widget.order.user.fullname),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),

                  // Name and email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order.user.fullname,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.order.user.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
              SizedBox(height: 16),

              // Contact info
              _buildContactRow(
                Icons.phone_rounded,
                'Số điện thoại',
                widget.order.user.phoneNumber.isNotEmpty
                    ? widget.order.user.phoneNumber
                    : 'Chưa cung cấp',
                widget.order.user.phoneNumber.isEmpty
                    ? textSecondaryColor
                    : textPrimaryColor,
              ),

              SizedBox(height: 12),

              // Address (optional)
              _buildContactRow(
                Icons.location_on_rounded,
                'Địa chỉ',
                'Chưa cung cấp',
                textSecondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Product information card
  Widget _buildProductCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.devices_rounded,
                    size: 40,
                    color: accentColor,
                  ),
                ),
              ),
              SizedBox(width: 16),

              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.order.campaign.product.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Mã: ${widget.order.campaign.product.productCode}',
                      style: TextStyle(fontSize: 14, color: textSecondaryColor),
                    ),
                    SizedBox(height: 8),

                    // Category and quantity
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.order.campaign.product.category.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: accentColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'SL: ${widget.order.quantity}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Đơn giá:',
                          style: TextStyle(
                            fontSize: 14,
                            color: textSecondaryColor,
                          ),
                        ),
                        Text(
                          currencyFormatter.format(
                            widget.order.campaign.product.price,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: goldAccent.withRed(240),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Campaign information card
  Widget _buildCampaignCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campaign name
              Text(
                widget.order.campaign.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimaryColor,
                ),
              ),
              SizedBox(height: 16),

              // Campaign details in a grid
              Row(
                children: [
                  // Start date
                  Expanded(
                    child: _buildInfoTile(
                      'Bắt đầu',
                      DateFormat(
                        'dd/MM/yyyy',
                      ).format(widget.order.campaign.startDate),
                      Icons.event_available_rounded,
                      accentColor,
                    ),
                  ),
                  // End date
                  Expanded(
                    child: _buildInfoTile(
                      'Kết thúc',
                      DateFormat(
                        'dd/MM/yyyy',
                      ).format(widget.order.campaign.endDate),
                      Icons.event_busy_rounded,
                      primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  // Min quantity
                  Expanded(
                    child: _buildInfoTile(
                      'SL tối thiểu',
                      widget.order.campaign.minQuantity.toString(),
                      Icons.remove_circle_outline_rounded,
                      Colors.orange,
                    ),
                  ),
                  // Max quantity
                  Expanded(
                    child: _buildInfoTile(
                      'SL tối đa',
                      widget.order.campaign.maxQuantity.toString(),
                      Icons.add_circle_outline_rounded,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Campaign status
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getCampaignStatusColor(
                        widget.order.campaign.status,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCampaignStatusIcon(widget.order.campaign.status),
                      color: _getCampaignStatusColor(
                        widget.order.campaign.status,
                      ),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trạng thái chiến dịch',
                        style: TextStyle(
                          color: textSecondaryColor,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        _getCampaignStatusText(widget.order.campaign.status),
                        style: TextStyle(
                          color: _getCampaignStatusColor(
                            widget.order.campaign.status,
                          ),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section title widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Contact information row
  Widget _buildContactRow(
    IconData icon,
    String label,
    String value,
    Color valueColor,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: accentColor, size: 20),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: textSecondaryColor, fontSize: 14),
            ),
            SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Info tile for grid layout
  Widget _buildInfoTile(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 13, color: textSecondaryColor),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
      ],
    );
  }

  // App bar icon button
  Widget _buildIconButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed, [
    Color? color,
  ]) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(12),
            child: Icon(icon, color: color ?? textPrimaryColor, size: 24),
          ),
        ),
      ),
    );
  }

  // Get initials from name
  String _getInitials(String name) {
    if (name.isEmpty) return '';
    List<String> nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return nameParts.first[0] + nameParts.last[0];
    } else {
      return nameParts.first[0];
    }
  }

  // Truncate order ID for display
  String _truncateId(String id) {
    if (id.length <= 12) return id;
    return id.substring(0, 6) + '...' + id.substring(id.length - 6);
  }

  // Get campaign status color
  Color _getCampaignStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return Colors.green;
      case 'SCHEDULED':
        return accentColor;
      case 'COMPLETED':
        return Colors.blue;
      case 'CANCELLED':
        return dangerColor;
      default:
        return textSecondaryColor;
    }
  }

  // Get campaign status icon
  IconData _getCampaignStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return Icons.play_circle_fill_rounded;
      case 'SCHEDULED':
        return Icons.schedule_rounded;
      case 'COMPLETED':
        return Icons.check_circle_rounded;
      case 'CANCELLED':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  // Get campaign status text
  String _getCampaignStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return 'Đang diễn ra';
      case 'SCHEDULED':
        return 'Lên lịch';
      case 'COMPLETED':
        return 'Đã kết thúc';
      case 'CANCELLED':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  // Delete confirmation dialog with improved button handling
  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: dangerColor.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: dangerColor,
                    size: 70,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Xác nhận xóa',
                        style: TextStyle(
                          color: textPrimaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Bạn có chắc chắn muốn xóa đơn hàng này không?',
                        style: TextStyle(color: textPrimaryColor, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Hành động này không thể hoàn tác.',
                        style: TextStyle(
                          color: textSecondaryColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        style: TextButton.styleFrom(
                          foregroundColor: textSecondaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        child: Text('Hủy', style: TextStyle(fontSize: 16)),
                      ),
                      Container(
                        height: 24,
                        width: 1,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      TextButton(
                        onPressed: () {
                          // Return true to indicate delete confirmation
                          Navigator.of(dialogContext).pop(true);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFFE53935),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Xóa',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    ).then((confirmed) {
      // Only proceed with deletion if user confirmed
      if (confirmed == true) {
        _deleteOrder();
      }
    });
  }

  // Completely rewritten delete order method to fix the widget deactivation issue
  Future<void> _deleteOrder() async {
    if (!mounted) return;

    try {
      // Show loading indicator
      setState(() {
        _isDeleting = true;
      });

      // Call API to delete order
      final result = await _orderNetwork.deleteOrder(widget.order.id);

      // Safety check - if widget is unmounted, don't proceed
      if (!mounted) return;

      // Hide loading indicator
      setState(() {
        _isDeleting = false;
      });

      final bool isSuccess = result['success'] == true;

      if (isSuccess) {
        // First navigate back with success result
        Navigator.of(context).pop({
          'deleted': true,
          'message': result['message'] ?? 'Đã xóa đơn hàng thành công',
        });

        // No more UI operations after navigation!
      } else {
        // For errors, show message in current screen (no navigation)
        _scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Không thể xóa đơn hàng'),
            backgroundColor: dangerColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Safety check - if widget is unmounted, don't proceed
      if (!mounted) return;

      // Hide loading
      setState(() {
        _isDeleting = false;
      });

      // Show error
      _scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Lỗi xảy ra: ${e.toString()}'),
          backgroundColor: dangerColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// Custom clipper for curved bottom edge
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0); // Top left
    path.lineTo(0, size.height * 0.85); // Bottom left with some space

    // Curved bottom
    path.quadraticBezierTo(
      size.width * 0.5, // Control point x
      size.height + 40, // Control point y (below the bottom edge)
      size.width, // End point x
      size.height * 0.85, // End point y
    );

    path.lineTo(size.width, 0); // Top right
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
