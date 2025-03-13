import 'package:flutter/material.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Giao dịch gần đây',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildTransactionItem(
          'Phạm Thị Thắm',
          '11 May 2023',
          '10.000.000đ',
          'assets/images/Tham-Nho/tham3.jpg',
        ),
        _buildTransactionItem(
          'Thắm nhỏ',
          '20 Jan 2024',
          '20.000.000đ',
          'assets/images/Tham-Nho/tham2.jpg',
        ),
        _buildTransactionItem(
          'Nguyễn Đan Huy',
          '14 Feb 2024',
          '3.000.000đ',
          'assets/images/Tham-Nho/tham1.jpg',
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    String name,
    String date,
    String amount,
    String imagePath,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Image container
          Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  // Fallback to a colored circle with initial
                  print('Error loading image: $exception');
                },
              ),
            ),
            child:
                imagePath.isEmpty
                    ? Center(
                      child: Text(
                        name.isNotEmpty ? name[0] : '?',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    : null,
          ),

          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(date, style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),

          // Amount
          Text(
            amount,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
