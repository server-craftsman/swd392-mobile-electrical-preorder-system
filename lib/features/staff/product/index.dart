import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductManagementPage extends StatefulWidget {
  @override
  _ProductManagementPageState createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> products = [
    {
      'id': 'P001',
      'name': 'Máy lạnh Panasonic Inverter 1.5 HP',
      'price': '12,500,000₫',
      'stock': 15,
      'status': 'Còn hàng',
      'image': 'assets/images/products/product1.jpg',
      'category': 'Máy lạnh',
      'description':
          'Máy lạnh Inverter tiết kiệm điện, làm lạnh nhanh, kháng khuẩn',
      'rating': 4.8,
      'reviews': 24,
    },
    {
      'id': 'P002',
      'name': 'Tủ lạnh Samsung Digital Inverter 300L',
      'price': '15,990,000₫',
      'stock': 8,
      'status': 'Còn hàng',
      'image': 'assets/images/products/product2.jpg',
      'category': 'Tủ lạnh',
      'description':
          'Tủ lạnh công nghệ Digital Inverter tiết kiệm điện, làm lạnh đa chiều',
      'rating': 4.7,
      'reviews': 18,
    },
    {
      'id': 'P003',
      'name': 'Máy giặt LG AI DD 10.5kg',
      'price': '13,900,000₫',
      'stock': 0,
      'status': 'Hết hàng',
      'image': 'assets/images/products/product3.jpg',
      'category': 'Máy giặt',
      'description':
          'Máy giặt thông minh với công nghệ AI DD, tiết kiệm nước và điện',
      'rating': 4.9,
      'reviews': 32,
    },
    {
      'id': 'P004',
      'name': 'Smart TV Sony 4K 55 inch',
      'price': '18,500,000₫',
      'stock': 5,
      'status': 'Còn hàng',
      'image': 'assets/images/products/product4.jpg',
      'category': 'Tivi',
      'description':
          'Smart TV 4K với công nghệ hình ảnh XR Processor, âm thanh vòm',
      'rating': 4.6,
      'reviews': 15,
    },
    {
      'id': 'P005',
      'name': 'Lò vi sóng Sharp R-G272VN',
      'price': '2,190,000₫',
      'stock': 12,
      'status': 'Còn hàng',
      'image': 'assets/images/products/product5.jpg',
      'category': 'Đồ gia dụng',
      'description': 'Lò vi sóng có nướng, dung tích 20L, công suất 800W',
      'rating': 4.5,
      'reviews': 9,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Còn hàng':
        return Color(0xFF1A237E);
      case 'Sắp hết':
        return Colors.orange;
      case 'Hết hàng':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getFilteredProducts(String category) {
    if (category == 'Tất cả') {
      return products
          .where(
            (product) =>
                product['name'].toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                product['id'].toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }
    return products
        .where(
          (product) =>
              product['category'] == category &&
              (product['name'].toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  product['id'].toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  )),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildCategoryTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductGrid('Tất cả'),
                _buildProductGrid('Máy lạnh'),
                _buildProductGrid('Tủ lạnh'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductDialog();
        },
        backgroundColor: Color(0xFF1A237E),
        child: Icon(Icons.add),
        elevation: 4,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quản lý sản phẩm',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Quản lý danh sách sản phẩm trong hệ thống',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Tìm kiếm sản phẩm...',
          prefixIcon: Icon(Icons.search, color: Color(0xFF1A237E)),
          suffixIcon:
              _searchQuery.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                  : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF1A237E), width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Color(0xFF1A237E),
        indicatorWeight: 3,
        labelColor: Color(0xFF1A237E),
        unselectedLabelColor: Colors.grey[600],
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        tabs: [
          Tab(text: 'Tất cả sản phẩm'),
          Tab(text: 'Máy lạnh'),
          Tab(text: 'Tủ lạnh'),
        ],
      ),
    );
  }

  Widget _buildProductGrid(String category) {
    final filteredProducts = _getFilteredProducts(category);

    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Không tìm thấy sản phẩm nào',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65, // Changed from 0.75 to give more vertical space
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    bool isOutOfStock = product['stock'] == 0;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero, // Remove default card margin
      color: Colors.white, // Set background color to white
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showProductDetails(product);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with status badge
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(product['image'], fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(product['status']),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      product['status'],
                      style: TextStyle(
                        color: _getStatusColor(product['status']),
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Product details - reduced padding
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['id'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  SizedBox(height: 2),
                  Text(
                    product['name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),

            Spacer(), // Push banners to bottom
            // Striped warning banner
            // if (product['id'].startsWith('P00'))
            //   Container(
            //     width: double.infinity,
            //     height: 16,
            //     decoration: BoxDecoration(
            //       image: DecorationImage(
            //         image: NetworkImage(
            //           'https://res.cloudinary.com/dsqbxgh88/image/upload/v1740990624/kmdyb1sxf02trfone3ht.jpg',
            //         ),
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),

            // "CÓ THỂ ĐẶT TRƯỚC QUA KỸ THUẬT" text
            if (product['id'].startsWith('P00'))
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 4),
                color: Colors.orange.shade100,
                child: Text(
                  'CÓ THỂ ĐẶT TRƯỚC QUA KỸ THUẬT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange.shade900,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // Out of stock indicator
            if (isOutOfStock)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 4),
                color: Colors.red.shade100,
                child: Text(
                  'HẾT HÀNG',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chi tiết sản phẩm',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Product details
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product image placeholder
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Product info
                        _buildInfoRow('Mã sản phẩm', product['id']),
                        _buildInfoRow('Tên sản phẩm', product['name']),
                        _buildInfoRow('Danh mục', product['category']),
                        _buildInfoRow('Giá bán', product['price']),
                        _buildInfoRow(
                          'Số lượng tồn',
                          product['stock'].toString(),
                        ),
                        _buildInfoRow('Trạng thái', product['status']),

                        SizedBox(height: 16),

                        // Description
                        Text(
                          'Mô tả sản phẩm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          product['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),

                        SizedBox(height: 24),

                        // Ratings
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            SizedBox(width: 4),
                            Text(
                              '${product['rating']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '(${product['reviews']} đánh giá)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.edit),
                                label: Text('Chỉnh sửa'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1A237E),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showEditProductDialog(product);
                                },
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.delete_outline),
                                label: Text('Xóa sản phẩm'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: Colors.red),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showDeleteConfirmation(product);
                                },
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Thêm sản phẩm mới',
              style: TextStyle(
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Mã sản phẩm',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Tên sản phẩm',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Giá bán',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Số lượng',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Danh mục',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'Máy lạnh',
                        child: Text('Máy lạnh'),
                      ),
                      DropdownMenuItem(
                        value: 'Tủ lạnh',
                        child: Text('Tủ lạnh'),
                      ),
                      DropdownMenuItem(
                        value: 'Máy giặt',
                        child: Text('Máy giặt'),
                      ),
                      DropdownMenuItem(value: 'Tivi', child: Text('Tivi')),
                      DropdownMenuItem(
                        value: 'Đồ gia dụng',
                        child: Text('Đồ gia dụng'),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Mô tả sản phẩm',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy', style: TextStyle(color: Colors.grey[600])),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add product logic
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm sản phẩm mới'),
                      backgroundColor: Color(0xFF1A237E),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A237E),
                ),
                child: Text('Thêm sản phẩm'),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
    );
  }

  void _showEditProductDialog(Map<String, dynamic> product) {
    // Similar to add product dialog but with pre-filled values
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Chỉnh sửa sản phẩm',
              style: TextStyle(
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Mã sản phẩm',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: TextEditingController(text: product['id']),
                    enabled: false,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Tên sản phẩm',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: TextEditingController(text: product['name']),
                  ),
                  // Other fields similar to add product
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy', style: TextStyle(color: Colors.grey[600])),
              ),
              ElevatedButton(
                onPressed: () {
                  // Update product logic
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã cập nhật sản phẩm'),
                      backgroundColor: Color(0xFF1A237E),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A237E),
                ),
                child: Text('Cập nhật'),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Xác nhận xóa',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Bạn có chắc chắn muốn xóa sản phẩm "${product['name']}" không? Hành động này không thể hoàn tác.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy', style: TextStyle(color: Colors.grey[600])),
              ),
              ElevatedButton(
                onPressed: () {
                  // Delete product logic
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã xóa sản phẩm'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Xóa sản phẩm'),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
    );
  }
}
