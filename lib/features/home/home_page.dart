import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/tham.jpg'),
                    radius: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Nguyễn Đan Huy\n0869872830',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
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
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Danh mục',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCategoryIcon(Icons.phone_android, 'Điện thoại',
                          color: Colors.redAccent),
                      _buildCategoryIcon(Icons.laptop, 'Laptop',
                          color: Colors.blueAccent),
                      _buildCategoryIcon(Icons.watch, 'Đồng hồ',
                          color: Colors.greenAccent),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Đơn hàng trước đây',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
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
                              Image.asset('assets/images/laptop.png',
                                  width: 30),
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
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label,
      {required Color color}) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}
