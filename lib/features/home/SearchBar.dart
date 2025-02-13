import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Tìm kiếm gì đó...',
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontStyle: FontStyle.italic,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VerticalDivider(
              color: Colors.grey.shade400,
              thickness: 1,
              width: 1,
            ),
            Icon(Icons.mic, color: Colors.grey.shade400),
          ],
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
