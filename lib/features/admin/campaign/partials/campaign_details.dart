import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/network/campaign/campaign.network.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';
import 'package:mobile_electrical_preorder_system/core/network/campaign/res/index.dart';
import 'package:google_fonts/google_fonts.dart';

class CampaignDetailsPage extends StatefulWidget {
  final String campaignId;

  const CampaignDetailsPage({Key? key, required this.campaignId})
    : super(key: key);

  @override
  _CampaignDetailsPageState createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage> {
  late Future<SingleCampaignResponse> _campaignFuture;
  bool _isLoading = false;

  // Luxurious color palette
  final Color _primaryColor = Color(0xFF1E293B); // Deep navy blue
  final Color _accentColor = Color(0xFFE0A458); // Gold accent
  final Color _backgroundColor = Color(0xFFF8FAFC); // Light background
  final Color _cardColor = Colors.white;
  final Color _textPrimaryColor = Color(0xFF1E293B); // Dark text
  final Color _textSecondaryColor = Color(0xFF64748B); // Secondary text

  // Status colors
  final Color _activeColor = Color(0xFF10B981); // Emerald
  final Color _completedColor = Color(0xFF3B82F6); // Blue
  final Color _canceledColor = Color(0xFFEF4444); // Red
  final Color _scheduledColor = Color(0xFFF59E0B); // Amber

  @override
  void initState() {
    super.initState();
    _loadCampaignDetails();
  }

  void _loadCampaignDetails() {
    setState(() {
      _campaignFuture = CampaignNetwork.getCampaignById(widget.campaignId);
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  String _getStatusText(String? status, String? startDate, String? endDate) {
    if (status == null || startDate == null || endDate == null)
      return 'Unknown';

    try {
      final now = DateTime.now();
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);

      if (status == 'CANCELED') {
        return 'Đã hủy';
      } else if (end.isBefore(now)) {
        return 'Đã hoàn thành';
      } else if (start.isBefore(now)) {
        return 'Đang hoạt động';
      } else {
        return 'Sắp diễn ra';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  Color _getStatusColor(String? status, String? startDate, String? endDate) {
    if (status == null || startDate == null || endDate == null)
      return Colors.grey;

    try {
      final now = DateTime.now();
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);

      if (status == 'CANCELED') {
        return _canceledColor;
      } else if (end.isBefore(now)) {
        return _completedColor;
      } else if (start.isBefore(now)) {
        return _activeColor;
      } else {
        return _scheduledColor;
      }
    } catch (e) {
      return Colors.grey;
    }
  }

  Future<void> _handleCancelCampaign() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: _cardColor,
            title: Text(
              'Xác nhận hủy chiến dịch',
              style: GoogleFonts.montserrat(
                color: _textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Bạn có chắc chắn muốn hủy chiến dịch này? Hành động này không thể hoàn tác.',
              style: GoogleFonts.montserrat(color: _textSecondaryColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Hủy bỏ',
                  style: GoogleFonts.montserrat(
                    color: _textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canceledColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Xác nhận hủy',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await CampaignNetwork.cancelCampaign(widget.campaignId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Đã hủy chiến dịch thành công',
                style: GoogleFonts.montserrat(),
              ),
              backgroundColor: _completedColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          // Navigate back to index page immediately after successful deletion
          Navigator.pop(context, true); // Pass true to indicate refresh needed
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: $e', style: GoogleFonts.montserrat()),
              backgroundColor: _canceledColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Chi tiết chiến dịch',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: _primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadCampaignDetails,
          ),
        ],
      ),
      body: FutureBuilder<SingleCampaignResponse>(
        future: _campaignFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: _canceledColor, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: GoogleFonts.montserrat(
                      color: _textPrimaryColor,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _loadCampaignDetails,
                    icon: Icon(Icons.refresh),
                    label: Text(
                      'Thử lại',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.campaign == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.campaign_outlined,
                    color: _textSecondaryColor,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Không tìm thấy thông tin chiến dịch',
                    style: GoogleFonts.montserrat(
                      color: _textPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _loadCampaignDetails,
                    icon: Icon(Icons.refresh),
                    label: Text(
                      'Thử lại',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final campaign = snapshot.data!.campaign;
          final statusText = _getStatusText(
            campaign.status,
            campaign.startDate.toString(),
            campaign.endDate.toString(),
          );
          final statusColor = _getStatusColor(
            campaign.status,
            campaign.startDate.toString(),
            campaign.endDate.toString(),
          );

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_backgroundColor, Color(0xFFE5E7EB)],
              ),
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16, 100, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campaign header
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 24),
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: statusColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    statusText,
                                    style: GoogleFonts.montserrat(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Text(
                            //   'ID: #${campaign.id}',
                            //   style: GoogleFonts.montserrat(
                            //     color: _textSecondaryColor,
                            //     fontSize: 12,
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          campaign.name,
                          style: GoogleFonts.montserrat(
                            color: _textPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 20),
                        Divider(color: Colors.grey.shade200),
                        SizedBox(height: 16),
                        _buildInfoItem(
                          icon: Icons.calendar_today,
                          color: _primaryColor,
                          title: 'Thời gian bắt đầu',
                          value: _formatDate(campaign.startDate.toString()),
                        ),
                        SizedBox(height: 16),
                        _buildInfoItem(
                          icon: Icons.event,
                          color: _accentColor,
                          title: 'Thời gian kết thúc',
                          value: _formatDate(campaign.endDate.toString()),
                        ),
                        SizedBox(height: 16),
                        _buildInfoItem(
                          icon: Icons.inventory_2_outlined,
                          color: statusColor,
                          title: 'Số lượng sản phẩm',
                          value:
                              'Tối thiểu: ${campaign.minQuantity} - Tối đa: ${campaign.maxQuantity}',
                        ),
                        SizedBox(height: 16),
                        _buildInfoItem(
                          icon: Icons.monetization_on_outlined,
                          color: Colors.green,
                          title: 'Tổng giá trị',
                          value: Helper.formatCurrency(campaign.totalAmount),
                        ),
                      ],
                    ),
                  ),

                  // Product section
                  if (campaign.product != null)
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thông tin sản phẩm',
                            style: GoogleFonts.montserrat(
                              color: _textPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _cardColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade100,
                                  ),
                                  child:
                                      campaign.product.imageProducts != null &&
                                              campaign
                                                  .product
                                                  .imageProducts
                                                  .isNotEmpty
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              campaign
                                                  .product
                                                  .imageProducts
                                                  .first
                                                  .imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey,
                                                  size: 30,
                                                );
                                              },
                                            ),
                                          )
                                          : Icon(
                                            Icons.inventory_2,
                                            color: _accentColor,
                                            size: 40,
                                          ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        campaign.product.name,
                                        style: GoogleFonts.montserrat(
                                          color: _textPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Giá: ${Helper.formatCurrency(campaign.product.price)}',
                                        style: GoogleFonts.montserrat(
                                          color: _textSecondaryColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Sản phẩm cao cấp',
                                            style: GoogleFonts.montserrat(
                                              color: _textSecondaryColor,
                                              fontSize: 12,
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
                        ],
                      ),
                    ),

                  // Action buttons
                  if (campaign.status != 'CANCELED' &&
                      !campaign.endDate.isBefore(DateTime.now()))
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quản lý chiến dịch',
                            style: GoogleFonts.montserrat(
                              color: _textPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.cancel_outlined),
                                  label: Text(
                                    'Hủy chiến dịch',
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _canceledColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed:
                                      _isLoading ? null : _handleCancelCampaign,
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
          );
        },
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  color: _textSecondaryColor,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  color: _textPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
