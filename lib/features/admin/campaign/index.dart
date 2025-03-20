import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/network/campaign/campaign.network.dart';
import 'package:mobile_electrical_preorder_system/core/network/campaign/res/index.dart';
import 'partials/create_campaign.dart';
import '../../../core/utils/helper.dart';
import 'dart:ui';
import 'partials/campaign_details.dart';

class ManageCampaignPage extends StatefulWidget {
  @override
  _ManageCampaignPageState createState() => _ManageCampaignPageState();
}

class _ManageCampaignPageState extends State<ManageCampaignPage>
    with SingleTickerProviderStateMixin {
  late Future<CampaignResponse> _campaignsFuture;
  TabController? _tabController; // Changed to nullable
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  // Luxury color palette
  final Color _primaryColor = Color(0xFF1A237E); // Deep navy blue
  final Color _accentColor = Color(0xFF7986CB); // Gold accent
  final Color _backgroundColor = Color(0xFFF5F7FA); // Light background
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF2D3748); // Dark text
  final Color _secondaryTextColor = Color(0xFF718096); // Secondary text

  // Status colors
  final Color _activeColor = Color(0xFF38B2AC); // Teal
  final Color _completedColor = Color(0xFF48BB78); // Green
  final Color _canceledColor = Color(0xFFE53E3E); // Red
  final Color _scheduledColor = Color(0xFFED8936); // Orange

  // Define campaign status types
  final List<String> _tabs = [
    'Tất cả',
    'Đang hoạt động',
    'Đã hoàn thành',
    'Đã hủy',
  ];

  // Map tab indices to API status values
  final Map<int, String?> _statusMap = {
    0: null, // All
    1: 'ACTIVE',
    2: 'COMPLETED',
    3: 'CANCELLED',
  };

  @override
  void initState() {
    super.initState();
    _campaignsFuture = CampaignNetwork.getCampaignList();

    // Initialize tab controller after the widget is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _tabController = TabController(length: _tabs.length, vsync: this);

          // Listen to tab changes to refresh data if needed
          _tabController?.addListener(() {
            if (_tabController != null && !_tabController!.indexIsChanging) {
              _refreshCampaigns();
            }
          });
        });
      }
    });

    // Add listener to search controller
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _tabController?.dispose(); // Use safe call
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    // Debounce search to avoid too many API calls
    Future.delayed(Duration(milliseconds: 500), () {
      if (_searchQuery == _searchController.text) {
        _refreshCampaigns();
      }
    });
  }

  void _refreshCampaigns() {
    final currentTabIndex = _tabController?.index ?? 0;
    final status = _statusMap[currentTabIndex];

    setState(() {
      _campaignsFuture = CampaignNetwork.getCampaignList(
        name: _searchQuery.isEmpty ? null : _searchQuery,
        status: status,
      );
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _refreshCampaigns();
      }
    });
  }

  void _openCreateCampaignDialog() async {
    // Show dialog and wait for the result
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder:
          (context) => CreateCampaignDialog(
            onCampaignCreated: () {
              // This callback is no longer used to show snackbar or refresh directly
              // It can be used for any additional actions needed before closing the dialog
            },
          ),
    );

    // Only proceed if we got a successful result (true)
    if (result == true) {
      // Explicitly refresh the campaigns list
      setState(() {
        _campaignsFuture = CampaignNetwork.getCampaignList();

        // Reset to the "All" tab to show the new campaign
        if (_tabController != null) {
          _tabController!.animateTo(0);
        }
      });

      // Now it's safe to show a SnackBar in the parent context
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Chiến dịch mới đã được tạo và đang hiển thị trong danh sách',
          ),
          backgroundColor: Color(0xFF48BB78), // Green success color
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _openCampaignDetails(String campaignId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CampaignDetailsPage(campaignId: campaignId),
      ),
    ).then((_) {
      // Refresh the list when returning from details page
      _refreshCampaigns();
    });
  }

  @override
  Widget build(BuildContext context) {
    // If tab controller is not initialized yet, show loading
    if (_tabController == null) {
      return Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          title: Text(
            'Quản lý chiến dịch',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          backgroundColor: _primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm chiến dịch...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  autofocus: true,
                )
                : Text(
                  'Quản lý chiến dịch',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
        backgroundColor: _primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () {
        //     if (_isSearching) {
        //       _toggleSearch();
        //     } else {
        //       Helper.navigateTo(context, '/admin/dashboard');
        //     }
        //   },
        // ),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       _isSearching ? Icons.close : Icons.search,
        //       color: Colors.white,
        //     ),
        //     onPressed: _toggleSearch,
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.refresh, color: Colors.white),
        //     onPressed: _refreshCampaigns,
        //   ),
        // ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            height: 60,
            child: TabBar(
              controller: _tabController,
              tabs:
                  _tabs
                      .map(
                        (tab) => Tab(
                          child: Text(
                            tab,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                      .toList(),
              indicatorColor: _accentColor,
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
            colors: [_backgroundColor, Color(0xFFEDF2F7)],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: List.generate(_tabs.length, (tabIndex) {
            return FutureBuilder<CampaignResponse>(
              future: _campaignsFuture,
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: _canceledColor,
                          size: 60,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: _textColor, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.data is! CampaignData) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.campaign_outlined,
                          color: _secondaryTextColor,
                          size: 60,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Không có chiến dịch nào',
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final campaigns = (snapshot.data!.data as CampaignData).content;

                if (campaigns.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.campaign_outlined,
                          color: _secondaryTextColor,
                          size: 60,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Không có chiến dịch ${_tabs[tabIndex].toLowerCase()}',
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _campaignsFuture = CampaignNetwork.getCampaignList(
                          name: _searchQuery.isEmpty ? null : _searchQuery,
                          status: _statusMap[tabIndex],
                        );
                      });
                    },
                    color: _accentColor,
                    backgroundColor: Colors.white,
                    strokeWidth: 3,
                    displacement: 50,
                    child: ListView.builder(
                      itemCount: campaigns.length,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final campaign = campaigns[index];

                        // Determine campaign status for UI
                        String statusText;
                        Color statusColor;

                        final now = DateTime.now();
                        final startDate = campaign.startDate;
                        final endDate = campaign.endDate;

                        if (campaign.status == 'CANCELLED') {
                          statusText = 'Đã hủy';
                          statusColor = _canceledColor;
                        } else if (campaign.status == 'COMPLETED') {
                          statusText = 'Đã hoàn thành';
                          statusColor = _completedColor;
                        } else if (campaign.status == 'ACTIVE') {
                          statusText = 'Đang hoạt động';
                          statusColor = _activeColor;
                        } else if (campaign.status == 'SCHEDULED') {
                          statusText = 'Sắp diễn ra';
                          statusColor = _scheduledColor;
                        } else {
                          statusText = 'Không xác định';
                          statusColor = _secondaryTextColor;
                        }

                        return Container(
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: _cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              _openCampaignDetails(campaign.id);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Campaign header with status
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _primaryColor.withOpacity(0.03),
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              campaign.name,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: _textColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                color: statusColor,
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              statusText,
                                              style: TextStyle(
                                                color: statusColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Campaign details
                                    Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Product info
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: _accentColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Icon(
                                                  Icons.devices,
                                                  color: _accentColor,
                                                  size: 24,
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Sản phẩm',
                                                      style: TextStyle(
                                                        color:
                                                            _secondaryTextColor,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      campaign.product.name,
                                                      style: TextStyle(
                                                        color: _textColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 16),

                                          // Date range
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: _primaryColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Icon(
                                                  Icons.date_range,
                                                  color: _primaryColor,
                                                  size: 24,
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Thời gian',
                                                      style: TextStyle(
                                                        color:
                                                            _secondaryTextColor,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      '${_formatDate(startDate ?? DateTime.now())} - ${_formatDate(endDate ?? DateTime.now())}',
                                                      style: TextStyle(
                                                        color: _textColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 16),

                                          // Quantity
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: statusColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Icon(
                                                  Icons.inventory_2,
                                                  color: statusColor,
                                                  size: 24,
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Số lượng',
                                                      style: TextStyle(
                                                        color:
                                                            _secondaryTextColor,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      'Tối thiểu: ${campaign.minQuantity} - Tối đa: ${campaign.maxQuantity}',
                                                      style: TextStyle(
                                                        color: _textColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateCampaignDialog,
        child: Icon(Icons.add),
        backgroundColor: _accentColor,
      ),
    );
  }

  // void _showDeleteConfirmation(BuildContext context, Campaign campaign) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext dialogContext) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         title: Text(
  //           'Xác nhận hủy',
  //           style: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
  //         ),
  //         content: Text(
  //           'Bạn có chắc chắn muốn hủy chiến dịch "${campaign.name}"?',
  //           style: TextStyle(color: _secondaryTextColor),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Hủy', style: TextStyle(color: _secondaryTextColor)),
  //             onPressed: () {
  //               Navigator.of(dialogContext).pop();
  //             },
  //           ),
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: _canceledColor,
  //               foregroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //             ),
  //             child: Text('Xác nhận'),
  //             onPressed: () async {
  //               Navigator.of(dialogContext).pop();
  //               try {
  //                 // Parse the ID to int if your API expects an int
  //                 await CampaignNetwork.cancelCampaign(int.parse(campaign.id));

  //                 // Show success message
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text('Đã hủy chiến dịch thành công'),
  //                     backgroundColor: _completedColor,
  //                     behavior: SnackBarBehavior.floating,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                   ),
  //                 );

  //                 // Refresh the campaign list
  //                 _refreshCampaigns();
  //               } catch (e) {
  //                 // Show error message
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text('Lỗi: Không thể hủy chiến dịch'),
  //                     backgroundColor: _canceledColor,
  //                     behavior: SnackBarBehavior.floating,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                   ),
  //                 );
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Helper method to format dates
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
