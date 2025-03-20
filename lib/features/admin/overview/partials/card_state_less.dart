import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './constants.dart';

class UpdateCardWidget extends StatelessWidget {
  const UpdateCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: DashboardColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
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
                    Icon(
                      Icons.circle,
                      color: DashboardColors.cancelled,
                      size: 10,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Cập nhật',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Ngày 12 tháng 2 năm 2025',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Doanh thu tăng ',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '40%',
                    style: GoogleFonts.poppins(
                      color: DashboardColors.delivered,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' trong 1 tuần',
                    style: GoogleFonts.poppins(
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
                  style: GoogleFonts.poppins(
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
}

// Keep the original function for backward compatibility
Widget buildUpdateCard() {
  return const UpdateCardWidget();
}
