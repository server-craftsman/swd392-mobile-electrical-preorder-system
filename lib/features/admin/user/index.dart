import 'package:flutter/material.dart';
import 'partials/date_selector.dart';
import 'partials/statistics_cards.dart';
import 'partials/recent_transactions.dart';

class CustomerManagePage extends StatefulWidget {
  @override
  _CustomerManagePageState createState() => _CustomerManagePageState();
}

class _CustomerManagePageState extends State<CustomerManagePage> {
  String _selectedMonth = 'January';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khách hàng', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            // Handle back action
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white),
                SizedBox(width: 5),
                DropdownButton<String>(
                  value: _selectedMonth,
                  dropdownColor: Colors.black,
                  iconEnabledColor: Colors.white,
                  underline: Container(),
                  items:
                      <String>['January', 'February', 'March'].map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMonth = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateSelector(),
              SizedBox(height: 20),
              StatisticsCards(),
              SizedBox(height: 1),
              RecentTransactions(),
              SizedBox(height: 10),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Handle see more action
              //     },
              //     child: Text('Xem thêm'),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.black,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
