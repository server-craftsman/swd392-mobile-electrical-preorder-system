import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: IconButton(
          icon: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Colors.redAccent),
              Text('Nhà Văn Hoá Sinh Viên',
                  style: TextStyle(fontSize: 12, color: Colors.black)),
              Icon(Icons.arrow_drop_down, color: Colors.redAccent),
            ],
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Danh mục sản phẩm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'view all',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CategoryIcon(label: 'Phones', icon: Icons.phone_android),
                  CategoryIcon(label: 'Computer', icon: Icons.computer),
                  CategoryIcon(label: 'Health', icon: Icons.health_and_safety),
                  CategoryIcon(label: 'Books', icon: Icons.book),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        filled: true,
                        fillColor: Colors.white10,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.5),
                    child: Container(
                      color: Colors.red, // Set background color to red
                      padding:
                          EdgeInsets.all(10), // Add padding to center the icon
                      child: SvgPicture.asset(
                        'assets/icons/SquaresPlus.svg',
                        width: 24,
                        height: 24,
                        color: Colors.white, // Set icon color to white
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SectionTitle(title: 'Hot sales', onTap: () {}),
              const SizedBox(height: 8),
              HotSalesCard(),
              const SizedBox(height: 16),
              SectionTitle(title: 'Best Seller', onTap: () {}),
              const SizedBox(height: 8),
              SizedBox(
                height: 400, // Set a fixed height to avoid infinite height
                child: BestSellerGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final String label;
  final IconData icon;

  const CategoryIcon({required this.label, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.redAccent,
          child: Icon(icon, size: 30, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SectionTitle({required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onTap,
          child: const Text(
            'see more',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}

class HotSalesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network('https://images-cdn.ispot.tv/ad/twlG/default-large.jpg',
              fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Iphone 12',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('10,000,000đ'),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: null,
                  child: Text(
                    'Buy now!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BestSellerGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 300,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.2, // Adjusted aspect ratio
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              // mainAxisExtent: 100,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      // Added Expanded to prevent overflow
                      child: Image.network(
                        'https://res.cloudinary.com/dsqbxgh88/image/upload/v1733295021/FB_IMG_1688794831597_mwxc4l.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity, // Ensure image takes full width
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Phạm Thị Thắm',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis)),
                          Text('Em là vô giá!',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
