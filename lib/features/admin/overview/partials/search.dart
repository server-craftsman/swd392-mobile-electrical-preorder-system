import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './constants.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DashboardColors.cardBackground,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm...',
          hintStyle: DashboardTextStyles.smallText,
          prefixIcon: Icon(Icons.search, color: DashboardColors.secondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: DashboardColors.secondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: DashboardColors.secondary),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
          fillColor: DashboardColors.cardBackground,
          filled: true,
        ),
      ),
    );
  }
}

// Keep the original function for backward compatibility
Widget buildSearchBar(BuildContext context) {
  return SearchBarWidget();
}
