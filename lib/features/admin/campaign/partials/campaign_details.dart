import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/network/campaign/campaign.network.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';

class CampaignDetailsPage extends StatefulWidget {
  final int campaignId;

  const CampaignDetailsPage({Key? key, required this.campaignId})
    : super(key: key);

  @override
  _CampaignDetailsPageState createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage> {
  late Future<dynamic> _campaignFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCampaignDetails();
  }

  void _loadCampaignDetails() {
    _campaignFuture = CampaignNetwork.getCampaignById(widget.campaignId);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getStatusText(String status, DateTime startDate, DateTime endDate) {
    final now = DateTime.now();

    if (status == 'CANCELED') {
      return 'Đã hủy';
    } else if (endDate.isBefore(now)) {
      return 'Đã hoàn thành';
    } else if (startDate.isBefore(now)) {
      return 'Đang hoạt động';
    } else {
      return 'Sắp diễn ra';
    }
  }

  Color _getStatusColor(String status, DateTime startDate, DateTime endDate) {
    final now = DateTime.now();

    if (status == 'CANCELED') {
      return Colors.red;
    } else if (endDate.isBefore(now)) {
      return Colors.green;
    } else if (startDate.isBefore(now)) {
      return Colors.blue;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết chiến dịch'),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit functionality
            },
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: _campaignFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No campaign data available'));
          }

          final campaign = snapshot.data.data;
          
          // Add null checks and safe parsing for dates
          final startDate = campaign.startDate != null 
              ? DateTime.parse(campaign.startDate.toString()) 
              : DateTime.now();
          final endDate = campaign.endDate != null 
              ? DateTime.parse(campaign.endDate.toString()) 
              : DateTime.now().add(Duration(days: 7));
              
          final statusText = _getStatusText(
            campaign.status ?? 'UNKNOWN',
            startDate,
            endDate,
          );
          final statusColor = _getStatusColor(
            campaign.status,
            startDate,
            endDate,
          );

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campaign header
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                campaign.name,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildInfoRow(
                          'Thời gian bắt đầu:',
                          _formatDate(startDate),
                        ),
                        SizedBox(height: 8),
                        _buildInfoRow(
                          'Thời gian kết thúc:',
                          _formatDate(endDate),
                        ),
                        SizedBox(height: 8),
                        _buildInfoRow(
                          'Mô tả:',
                          campaign.description ?? 'Không có mô tả',
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Campaign products section
                Text(
                  'Sản phẩm trong chiến dịch',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child:
                        campaign.products != null &&
                                campaign.products.isNotEmpty
                            ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: campaign.products.length,
                              itemBuilder: (context, index) {
                                final product = campaign.products[index];
                                return ListTile(
                                  title: Text(product.name),
                                  subtitle: Text(
                                    'Giá: ${Helper.formatCurrency(product.price)}',
                                  ),
                                  leading:
                                      product.imageUrl != null
                                          ? Image.network(
                                            product.imageUrl,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Icon(
                                                Icons.image_not_supported,
                                              );
                                            },
                                          )
                                          : Icon(Icons.inventory),
                                );
                              },
                            )
                            : Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'Không có sản phẩm trong chiến dịch này',
                                ),
                              ),
                            ),
                  ),
                ),

                SizedBox(height: 24),

                // Action buttons
                if (campaign.status != 'CANCELED' &&
                    !endDate.isBefore(DateTime.now()))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.cancel),
                        label: Text('Hủy chiến dịch'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onPressed:
                            _isLoading
                                ? null
                                : () async {
                                  // Show confirmation dialog
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: Text('Xác nhận hủy'),
                                          content: Text(
                                            'Bạn có chắc chắn muốn hủy chiến dịch này?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: Text('Không'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              child: Text('Có'),
                                            ),
                                          ],
                                        ),
                                  );

                                  if (confirm == true) {
                                    setState(() => _isLoading = true);
                                    try {
                                      await CampaignNetwork.cancelCampaign(
                                        widget.campaignId,
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Đã hủy chiến dịch thành công',
                                          ),
                                        ),
                                      );
                                      _loadCampaignDetails();
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text('Lỗi: $e')),
                                      );
                                    } finally {
                                      setState(() => _isLoading = false);
                                    }
                                  }
                                },
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(width: 8),
        Expanded(child: Text(value, style: TextStyle(color: Colors.black54))),
      ],
    );
  }
}
