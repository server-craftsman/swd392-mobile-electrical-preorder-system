import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/network/campaign/campaign.network.dart';
import 'package:mobile_electrical_preorder_system/core/network/campaign/res/index.dart';
import 'partials/create_campaign.dart';
import '../../../core/utils/helper.dart';

class ManageCampaignPage extends StatefulWidget {
  @override
  _ManageCampaignPageState createState() => _ManageCampaignPageState();
}

class _ManageCampaignPageState extends State<ManageCampaignPage>
    with SingleTickerProviderStateMixin {
  late Future<CampaignResponse> _campaignsFuture;
  TabController? _tabController; // Changed to nullable

  // Define campaign status types
  final List<String> _tabs = [
    'Tất cả',
    'Đang hoạt động',
    'Đã hoàn thành',
    'Đã hủy',
  ];

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
  }

  @override
  void dispose() {
    _tabController?.dispose(); // Use safe call
    super.dispose();
  }

  void _refreshCampaigns() {
    setState(() {
      _campaignsFuture = CampaignNetwork.getCampaignList();
    });
  }

  void _showCreateCampaignDialog() {
    showDialog(
      context: context,
      builder:
          (dialogContext) => CreateCampaignDialog(
            onCampaignCreated: () {
              // Refresh the campaign list
              setState(() {
                _campaignsFuture = CampaignNetwork.getCampaignList();
              });

              // Use a post-frame callback to ensure the Scaffold is available
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Campaign created successfully')),
                  );
                }
              });
            },
          ),
    );
  }

  // Helper method to filter campaigns based on status
  List<dynamic> _filterCampaigns(List<dynamic> campaigns, int tabIndex) {
    if (tabIndex == 0) return campaigns; // All campaigns

    final now = DateTime.now();

    return campaigns.where((campaign) {
      final startDate = DateTime.parse(campaign.startDate.toString());
      final endDate = DateTime.parse(campaign.endDate.toString());

      switch (tabIndex) {
        case 1: // Active campaigns
          return startDate.isBefore(now) &&
              endDate.isAfter(now) &&
              campaign.status != 'CANCELED';
        case 2: // Completed campaigns
          return endDate.isBefore(now) && campaign.status != 'CANCELED';
        case 3: // Canceled campaigns
          return campaign.status == 'CANCELED';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // If tab controller is not initialized yet, show loading
    if (_tabController == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quản lý chiến dịch'),
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý chiến dịch'),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Helper.navigateTo(context, '/admin/dashboard');
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(_tabs.length, (tabIndex) {
          return FutureBuilder<CampaignResponse>(
            future: _campaignsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.data.content.isEmpty) {
                return Center(child: Text('No campaigns available'));
              }

              final allCampaigns = snapshot.data!.data.content;
              final filteredCampaigns = _filterCampaigns(
                allCampaigns,
                tabIndex,
              );

              if (filteredCampaigns.isEmpty) {
                return Center(
                  child: Text(
                    'No ${_tabs[tabIndex].toLowerCase()} campaigns available',
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredCampaigns.length,
                itemBuilder: (context, index) {
                  final campaign = filteredCampaigns[index];

                  // Determine campaign status for UI
                  String statusText;
                  Color statusColor;

                  final now = DateTime.now();
                  final startDate = DateTime.parse(
                    campaign.startDate.toString(),
                  );
                  final endDate = DateTime.parse(campaign.endDate.toString());

                  if (campaign.status == 'CANCELED') {
                    statusText = 'Đã hủy';
                    statusColor = Colors.red;
                  } else if (endDate.isBefore(now)) {
                    statusText = 'Đã hoàn thành';
                    statusColor = Colors.green;
                  } else if (startDate.isBefore(now)) {
                    statusText = 'Đang hoạt động';
                    statusColor = Colors.blue;
                  } else {
                    statusText = 'Sắp diễn ra';
                    statusColor = Colors.orange;
                  }

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    color:
                        Colors
                            .white, // Explicitly setting card background to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Adding rounded corners
                      side: BorderSide(
                        color: Colors.grey.shade200,
                      ), // Adding subtle border
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        campaign.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Từ: ${_formatDate(startDate)} - Đến: ${_formatDate(endDate)}',
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Implement edit functionality
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Implement delete functionality
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateCampaignDialog,
        hoverColor: Colors.black,
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
    );
  }

  // Helper method to format dates
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
