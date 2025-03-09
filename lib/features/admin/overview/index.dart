import 'package:flutter/material.dart';
import './partials/dashboard.dart';
import './partials/search.dart' as search_widget;
import './partials/card_state_less.dart' as card_widget;
import './partials/transaction.dart' as transaction_widget;

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed search bar at the top
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: search_widget.buildSearchBar(context),
            ),
            // Scrollable content below the search bar
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      card_widget.buildUpdateCard(),
                      const SizedBox(height: 20),
                      const OverviewPage(),
                      const SizedBox(height: 20),
                      transaction_widget.buildTransactionList(),
                      const SizedBox(height: 20),
                    ],
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
