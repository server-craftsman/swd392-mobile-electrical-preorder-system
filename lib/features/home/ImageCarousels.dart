import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: PageView.builder(
        itemCount: 3,
        controller: PageController(
          initialPage: 0,
          viewportFraction: 1,
        ),
        itemBuilder: (context, index) {
          final images = [
            'https://images.ctfassets.net/hrltx12pl8hq/5orfKJqG0N9UopDnOVn2BW/1a2e92f5474911a4631722a6e70e7c5f/ezgif-5-44fa6284e5f3.gif',
            'https://images.ctfassets.net/hrltx12pl8hq/5orfKJqG0N9UopDnOVn2BW/1a2e92f5474911a4631722a6e70e7c5f/ezgif-5-44fa6284e5f3.gif',
            'https://images.ctfassets.net/hrltx12pl8hq/5orfKJqG0N9UopDnOVn2BW/1a2e92f5474911a4631722a6e70e7c5f/ezgif-5-44fa6284e5f3.gif',
          ];
          return Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                images[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        onPageChanged: (index) {
          Future.delayed(Duration(seconds: 3), () {
            final nextPage = (index + 1) % 3;
            PageController().animateToPage(
              nextPage,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          });
        },
      ),
    );
  }
}
