import 'package:flutter/material.dart';

Widget buildTransactionList() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Giao hàng',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      _buildTransactionItem(
        'Áo cà sa',
        'Ngày 12 tháng 7 năm 2024',
        'Đã hoàn thành',
        'assets/icons/ca_sa.jpg',
      ),
      _buildTransactionItem(
        'Tay nải',
        'Ngày 12 tháng 7 năm 2024',
        'Đang xử lý',
        'assets/icons/tay_nai.jpg',
      ),
      _buildTransactionItem(
        'Bình bát',
        'Ngày 12 tháng 7 năm 2024',
        'Đang xử lý',
        'assets/icons/binh_bat.jpg',
      ),
      _buildTransactionItem(
        'Chuỗi hạt + Ông Giáo',
        'Ngày 12 tháng 7 năm 2024',
        'Đang xử lý',
        'assets/icons/chuoi_hat_zao_lang.jpg',
      ),
      _buildTransactionItem(
        'Áo cà sa Thích Minh Tuệ',
        'Ngày 12 tháng 7 năm 2024',
        'Đang xử lý',
        'assets/icons/ao_ca_sa_minh_tue.jpg',
      ),
    ],
  );
}

Widget _buildTransactionItem(
  String title,
  String date,
  String status,
  String? imagePath,
) {
  return ListTile(
    leading:
        imagePath != null
            ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                imagePath,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            )
            : Icon(Icons.circle, color: Colors.grey),
    title: Text(title),
    subtitle: Text(date),
    trailing: Text(
      status,
      style: TextStyle(
        color: status == 'Đã hoàn thành' ? Colors.green : Colors.orange,
      ),
    ),
  );
}
