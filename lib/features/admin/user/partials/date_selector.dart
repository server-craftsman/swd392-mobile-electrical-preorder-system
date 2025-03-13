import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildDateItem('Mon', '17', false),
          _buildDateItem('Tue', '18', false),
          _buildDateItem('Wed', '20', true),
          _buildDateItem('Thu', '21', false),
          _buildDateItem('Fri', '22', false),
          _buildDateItem('Sat', '23', false),
          _buildDateItem('Sun', '24', false),
        ],
      ),
    );
  }

  Widget _buildDateItem(String day, String date, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          Text(day, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 5),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF002B1F) : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                date,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
