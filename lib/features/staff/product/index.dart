import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_electrical_preorder_system/core/network/product/product_network.dart';
import 'partials/create.dart';
import 'partials/details.dart';
import 'partials/update.dart';
import 'partials/delete.dart';

class ProductManagementPage extends StatefulWidget {
  @override
  _ProductManagementPageState createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> _fetchedProducts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Multi-select related variables
  bool _isMultiSelectMode = false;
  Set<String> _selectedProductIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchProducts();
  }

  void _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final response = await ProductNetwork.getProductList();
      setState(() {
        _fetchedProducts =
            response.data.content
                .map(
                  (product) => {
                    'id': product.id,
                    'productCode': product.productCode,
                    'name': product.name,
                    'price': product.price.toString(),
                    'stock':
                        product.quantity, // Add stock field for compatibility
                    'quantity': product.quantity,
                    'status':
                        product.status == 'AVAILABLE' ? 'Còn hàng' : 'Hết hàng',
                    'imageUrl':
                        product.imageProducts.isNotEmpty
                            ? product.imageProducts.first.imageUrl
                            : 'assets/images/default.jpg',
                    'category': product.category.name,
                    'description': product.description ?? '',
                    'rating': 0.0, // Default value
                    'reviews': 0, // Default value
                  },
                )
                .toList();
        _isLoading = false;

        // Clear selections when products are refreshed
        _selectedProductIds.clear();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load products: $e';
        _isLoading = false;
      });
    }
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
    final products = _fetchedProducts;
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

  void _toggleMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      // Clear selections when toggling multiselect mode
      if (!_isMultiSelectMode) {
        _selectedProductIds.clear();
      }
    });
  }

  void _toggleProductSelection(String productId) {
    setState(() {
      if (_selectedProductIds.contains(productId)) {
        _selectedProductIds.remove(productId);
      } else {
        _selectedProductIds.add(productId);
      }
    });
  }

  void _selectAllProducts(String category) {
    final products = _getFilteredProducts(category);
    setState(() {
      if (_selectedProductIds.length == products.length) {
        // If all are selected, clear selection
        _selectedProductIds.clear();
      } else {
        // Otherwise select all
        _selectedProductIds = products.map((p) => p['id'] as String).toSet();
      }
    });
  }

  Future<void> _deleteSelectedProducts() async {
    if (_selectedProductIds.isEmpty) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Xác nhận xóa nhiều sản phẩm',
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              'Bạn có chắc chắn muốn xóa ${_selectedProductIds.length} sản phẩm đã chọn? Hành động này không thể hoàn tác.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Xóa sản phẩm'),
              ),
            ],
          ),
    );

    if (confirmed != true) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Call the API to delete multiple products
      final result = await ProductNetwork.deleteMultipleProducts(
        _selectedProductIds.toList(),
      );

      // Hide loading indicator
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xóa ${_selectedProductIds.length} sản phẩm'),
          backgroundColor: Colors.red[700],
        ),
      );

      // Exit multi-select mode and refresh products
      setState(() {
        _isMultiSelectMode = false;
        _selectedProductIds.clear();
      });
      _fetchProducts();
    } catch (e) {
      // Hide loading indicator
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi xóa sản phẩm: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Column(
                children: [
                  _buildHeader(),
                  _buildSearchBar(),
                  _buildCategoryTabs(),
                  if (_isMultiSelectMode) _buildMultiSelectActionBar(),
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
      floatingActionButton:
          _isMultiSelectMode
              ? null // Hide FAB in multi-select mode
              : FloatingActionButton(
                onPressed: () {
                  _showAddProductDialog();
                },
                backgroundColor: Color(0xFF1A237E),
                child: Icon(Icons.add),
                elevation: 4,
              ),
    );
  }

  Widget _buildMultiSelectActionBar() {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            'Đã chọn: ${_selectedProductIds.length} sản phẩm',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
          Spacer(),
          TextButton.icon(
            icon: Icon(Icons.select_all),
            label: Text('Chọn tất cả'),
            onPressed: () {
              _selectAllProducts(
                _tabController.index == 0
                    ? 'Tất cả'
                    : _tabController.index == 1
                    ? 'Máy lạnh'
                    : 'Tủ lạnh',
              );
            },
          ),
          SizedBox(width: 8),
          ElevatedButton.icon(
            icon: Icon(Icons.delete),
            label: Text('Xóa đã chọn'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed:
                _selectedProductIds.isEmpty ? null : _deleteSelectedProducts,
          ),
        ],
      ),
    );
  }

  // UI Builder methods
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          Expanded(
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
          ),
          IconButton(
            icon: Icon(
              _isMultiSelectMode ? Icons.close : Icons.select_all,
              color: Color(0xFF1A237E),
            ),
            onPressed: _toggleMultiSelectMode,
            tooltip:
                _isMultiSelectMode ? 'Thoát chọn nhiều' : 'Chọn nhiều sản phẩm',
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
        childAspectRatio: 0.65,
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
    bool isOutOfStock = product['quantity'] == 0;
    bool isSelected = _selectedProductIds.contains(product['id']);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: isSelected ? Colors.blue[50] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isSelected
                ? BorderSide(color: Color(0xFF1A237E), width: 2)
                : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (_isMultiSelectMode) {
            _toggleProductSelection(product['id']);
          } else {
            _showProductDetails(product);
          }
        },
        onLongPress: () {
          if (!_isMultiSelectMode) {
            _toggleMultiSelectMode();
            _toggleProductSelection(product['id']);
          }
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
                    child: Image.network(
                      product['imageUrl'] ?? 'assets/images/default.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/default.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
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
                        color: _getStatusColor(product['status'] ?? ''),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      product['status'] ?? 'Unknown',
                      style: TextStyle(
                        color: _getStatusColor(product['status'] ?? ''),
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                if (_isMultiSelectMode)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF1A237E) : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFF1A237E), width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child:
                            isSelected
                                ? Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                                : SizedBox(width: 16, height: 16),
                      ),
                    ),
                  ),
              ],
            ),

            // Product details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? 'Unknown Product',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 0.3,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        size: 14,
                        color: Colors.amber[700],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${_formatPrice(product['price'] ?? "0")} VNĐ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(
                      product['description'] != null &&
                              product['description'].length > 50
                          ? '${product['description']}'.substring(0, 50) + '...'
                          : '${product['description'] ?? "No description"}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

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

  // Action methods using the partial components
  void _showAddProductDialog() {
    CreateProductDialog.show(context, _fetchProducts);
  }

  void _showProductDetails(Map<String, dynamic> product) {
    ProductDetailsView.show(
      context,
      product,
      _showEditProductDialog,
      _showDeleteConfirmation,
    );
  }

  void _showEditProductDialog(Map<String, dynamic> product) {
    UpdateProductDialog.show(context, product, _fetchProducts);
  }

  void _showDeleteConfirmation(Map<String, dynamic> product) {
    DeleteProductDialog.show(context, product, _fetchProducts);
  }

  // Helper methods
  String _formatPrice(String priceStr) {
    try {
      double price = double.parse(priceStr);
      return price
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    } catch (e) {
      return priceStr;
    }
  }
}
