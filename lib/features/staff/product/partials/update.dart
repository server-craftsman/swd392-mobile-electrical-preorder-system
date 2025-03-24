import 'package:flutter/material.dart';
import 'dart:io';
import 'package:mobile_electrical_preorder_system/core/network/product/product_network.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProductDialog {
  static void show(
    BuildContext context,
    Map<String, dynamic> product,
    Function onProductUpdated,
  ) {
    // Form controllers initialized with current product values
    final TextEditingController productCodeController = TextEditingController(
      text: product['productCode'],
    );
    final TextEditingController nameController = TextEditingController(
      text: product['name'],
    );
    final TextEditingController priceController = TextEditingController(
      text: product['price'],
    );
    final TextEditingController quantityController = TextEditingController(
      text: product['quantity'].toString(),
    );
    final TextEditingController descriptionController = TextEditingController(
      text: product['description'],
    );

    // Get current category or default to Phone
    String selectedCategory = product['category'] ?? 'Phone';
    String selectedCategoryId =
        '66547ffc-72db-4c1a-88b6-30697ab95495'; // Default to Phone

    // Map category name to ID if known
    if (selectedCategory == 'Phone') {
      selectedCategoryId = '66547ffc-72db-4c1a-88b6-30697ab95495';
    } else if (selectedCategory == 'Laptop') {
      selectedCategoryId = '0a903a10-99e7-4b8a-aef0-513258404ffc';
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _UpdateProductDialogContent(
          dialogContext: dialogContext,
          product: product,
          productCodeController: productCodeController,
          nameController: nameController,
          priceController: priceController,
          quantityController: quantityController,
          descriptionController: descriptionController,
          initialCategory: selectedCategory,
          initialCategoryId: selectedCategoryId,
          onProductUpdated: onProductUpdated,
        );
      },
    );
  }
}

class _UpdateProductDialogContent extends StatefulWidget {
  final BuildContext dialogContext;
  final Map<String, dynamic> product;
  final TextEditingController productCodeController;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final TextEditingController descriptionController;
  final String initialCategory;
  final String initialCategoryId;
  final Function onProductUpdated;

  const _UpdateProductDialogContent({
    Key? key,
    required this.dialogContext,
    required this.product,
    required this.productCodeController,
    required this.nameController,
    required this.priceController,
    required this.quantityController,
    required this.descriptionController,
    required this.initialCategory,
    required this.initialCategoryId,
    required this.onProductUpdated,
  }) : super(key: key);

  @override
  _UpdateProductDialogContentState createState() =>
      _UpdateProductDialogContentState();
}

class _UpdateProductDialogContentState
    extends State<_UpdateProductDialogContent> {
  final List<File> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();
  String _selectedCategory = '';
  String _selectedCategoryId = '';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _selectedCategoryId = widget.initialCategoryId;
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? pickedImages = await _imagePicker.pickMultiImage();
      if (pickedImages != null && pickedImages.isNotEmpty) {
        setState(() {
          for (var image in pickedImages) {
            _selectedImages.add(File(image.path));
          }
        });
      }
    } catch (e) {
      print('Error picking images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi chọn ảnh: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Cập nhật sản phẩm',
        style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widget.productCodeController,
              decoration: InputDecoration(
                labelText: 'Mã sản phẩm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              enabled: false, // Product code should not be editable
            ),
            SizedBox(height: 16),
            TextField(
              controller: widget.nameController,
              decoration: InputDecoration(
                labelText: 'Tên sản phẩm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: widget.priceController,
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
              controller: widget.quantityController,
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
              value: _selectedCategory,
              items: [
                DropdownMenuItem(value: 'Phone', child: Text('Phone')),
                DropdownMenuItem(value: 'Laptop', child: Text('Laptop')),
                // Add more categories as needed
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  // Map category name to ID
                  if (value == 'Phone') {
                    _selectedCategoryId =
                        '66547ffc-72db-4c1a-88b6-30697ab95495';
                  } else if (value == 'Laptop') {
                    _selectedCategoryId =
                        '0a903a10-99e7-4b8a-aef0-513258404ffc';
                  }
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: widget.descriptionController,
              decoration: InputDecoration(
                labelText: 'Mô tả sản phẩm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24),

            // Image picker section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hình ảnh sản phẩm mới',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.add_photo_alternate),
                      label: Text('Thêm ảnh'),
                      onPressed: _pickImages,
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Current product image preview
                if (widget.product['imageUrl'] != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ảnh hiện tại:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Image.network(
                          widget.product['imageUrl'],
                          height: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.red,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 8),

                // New selected images
                Container(
                  height: _selectedImages.isEmpty ? 100 : 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child:
                      _selectedImages.isEmpty
                          ? Center(
                            child: Text(
                              'Chưa có ảnh mới nào được chọn',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 1,
                                  ),
                              itemCount: _selectedImages.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.file(
                                        _selectedImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () => _removeImage(index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          padding: EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.close,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                ),
                if (_selectedImages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${_selectedImages.length} hình ảnh mới được chọn',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1A237E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                SizedBox(height: 8),
                Text(
                  'Lưu ý: Hình ảnh mới sẽ thay thế hình ảnh cũ.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
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
          onPressed: () => _submitUpdate(),
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1A237E)),
          child: Text('Cập nhật'),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Future<void> _submitUpdate() async {
    // Validate inputs
    if (widget.nameController.text.isEmpty ||
        widget.priceController.text.isEmpty ||
        widget.quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin sản phẩm'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create updated product data
    final updatedProductData = {
      'id': widget.product['id'],
      'productCode': widget.productCodeController.text,
      'name': widget.nameController.text,
      'quantity': int.tryParse(widget.quantityController.text) ?? 0,
      'description': widget.descriptionController.text,
      'price': double.tryParse(widget.priceController.text) ?? 0,
      'position': widget.product['position'] ?? 0,
      'category': {'id': _selectedCategoryId, 'name': _selectedCategory},
      'oldImageProducts': widget.product['oldImageProducts'] ?? [],
    };

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Log update information
      print('Updating product with ${_selectedImages.length} new images');

      // Call the updateProduct API method
      final result = await ProductNetwork.updateProduct(
        updatedProductData,
        _selectedImages.isNotEmpty ? _selectedImages : null,
      );

      // Hide loading indicator
      Navigator.pop(context);

      // Close dialog
      Navigator.pop(widget.dialogContext);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['success'] == false
                ? 'Lỗi: ${result['message']}'
                : 'Đã cập nhật sản phẩm',
          ),
          backgroundColor:
              result['success'] == false ? Colors.red : Color(0xFF1A237E),
        ),
      );

      // Call callback to refresh product list
      widget.onProductUpdated();
    } catch (e) {
      // Hide loading indicator
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
