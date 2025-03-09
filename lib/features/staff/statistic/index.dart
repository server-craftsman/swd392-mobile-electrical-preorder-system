import 'package:flutter/material.dart';

class StatisticPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: 'Month',
              items:
                  ['Day', 'Week', 'Month']
                      .map(
                        (String value) =>
                            DropdownMenuItem(value: value, child: Text(value)),
                      )
                      .toList(),
              onChanged: (_) {},
            ),
            SizedBox(height: 16),
            Text('Total Orders: 45', style: TextStyle(fontSize: 18)),
            Text('Revenue: \$5000', style: TextStyle(fontSize: 18)),
            Text('Cancelled: 5', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text('Export Report')),
          ],
        ),
      ),
    );
  }
}
