import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/network/campaign/campaign.network.dart';
import 'package:mobile_electrical_preorder_system/core/network/campaign/res/index.dart';

class ManageCampaignPage extends StatefulWidget {
  @override
  _ManageCampaignPageState createState() => _ManageCampaignPageState();
}

class _ManageCampaignPageState extends State<ManageCampaignPage> {
  late Future<CampaignResponse> _campaignsFuture;

  @override
  void initState() {
    super.initState();
    _campaignsFuture = CampaignNetwork.getCampaignList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý chiến dịch'),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: FutureBuilder<CampaignResponse>(
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

          final campaigns = snapshot.data!.data.content;

          return ListView.builder(
            itemCount: campaigns.length,
            itemBuilder: (context, index) {
              final campaign = campaigns[index];
              return ListTile(
                title: Text(
                  campaign.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${campaign.startDate.toString()} - ${campaign.endDate.toString()}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Implement edit functionality
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Implement delete functionality
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add campaign functionality
        },
        hoverColor: Colors.black,
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
    );
  }
}
