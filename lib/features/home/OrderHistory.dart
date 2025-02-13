import 'package:flutter/material.dart';

class OrderHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đã giao hàng',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Vào Thứ Tư, 27 Tháng 7 2022',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Image.asset('assets/images/phone.png', width: 30),
                const SizedBox(width: 10),
                Image.asset('assets/images/laptop.png', width: 30),
                const SizedBox(width: 10),
                Image.asset('assets/images/watch.png', width: 30),
                const SizedBox(width: 10),
                Text('+5 Món khác'),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Mã đơn hàng: #28292999',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Tổng cộng: 123.000đ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Đặt hàng lại'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Đặt hàng lại, nhận ưu đãi 10%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
