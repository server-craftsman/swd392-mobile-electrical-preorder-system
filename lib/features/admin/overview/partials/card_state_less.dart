import 'package:flutter/material.dart';

Widget buildUpdateCard() {
  return Card(
    color: Color(0xFF002B1F), // Dark green color
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, color: Colors.red, size: 10),
                  SizedBox(width: 8),
                  Text(
                    'Cập nhật',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              Icon(Icons.more_vert, color: Colors.white),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Ngày 12 tháng 2 năm 2025',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Doanh thu tăng ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '40%',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' trong 1 tuần',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Xem thống kê',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
              Icon(Icons.arrow_right, color: Colors.white),
            ],
          ),
        ],
      ),
    ),
  );
}
