import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:mobile_electrical_preorder_system/core/network/product/product_network.dart';
import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';
import 'package:image_picker/image_picker.dart';

/// Dialog for creating a new product
/// Optimized to prevent ANR issues with image handling and surface rendering
class CreateProductDialog {
  static void show(BuildContext context, Function onProductCreated) {
    // Create controllers outside of the build method
    final TextEditingController productCodeController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    // Default values
    String selectedCategory = 'Phone';
    String selectedCategoryId = '66547ffc-72db-4c1a-88b6-30697ab95495';

    // Present dialog with optimized memory usage
    showDialog(
      context: context,
      // Use barrierDismissible to allow easy dismissal if performance issue occurs
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return _CreateProductDialogContent(
          dialogContext: dialogContext,
          productCodeController: productCodeController,
          nameController: nameController,
          priceController: priceController,
          quantityController: quantityController,
          descriptionController: descriptionController,
          initialCategory: selectedCategory,
          initialCategoryId: selectedCategoryId,
          onProductCreated: onProductCreated,
        );
      },
    );
  }
}

class _CreateProductDialogContent extends StatefulWidget {
  final BuildContext dialogContext;
  final TextEditingController productCodeController;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final TextEditingController descriptionController;
  final String initialCategory;
  final String initialCategoryId;
  final Function onProductCreated;

  const _CreateProductDialogContent({
    Key? key,
    required this.dialogContext,
    required this.productCodeController,
    required this.nameController,
    required this.priceController,
    required this.quantityController,
    required this.descriptionController,
    required this.initialCategory,
    required this.initialCategoryId,
    required this.onProductCreated,
  }) : super(key: key);

  @override
  _CreateProductDialogContentState createState() =>
      _CreateProductDialogContentState();
}

class _CreateProductDialogContentState
    extends State<_CreateProductDialogContent>
    with WidgetsBindingObserver {
  // Limit number of images to avoid memory issues
  static const int _maxImages = 3; // Reduced to 3 for better performance

  // Use RepaintBoundary for images to prevent full UI redraws
  final GlobalKey _imagesKey = GlobalKey();

  // Image state - use paths rather than File objects to reduce memory issues
  final List<String> _selectedImagePaths = [];
  final ImagePicker _imagePicker = ImagePicker();

  // Track submitted files for cleanup
  final List<File> _filesToCleanup = [];

  // Form state
  String _selectedCategory = '';
  String _selectedCategoryId = '';
  bool _isProcessing = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  // Frame callback to detect jank
  late Ticker _ticker;
  int _slowFrames = 0;

  // Track whether API client is uploading
  bool get _isUploadingInProgress => ApiClient().isUploadingFiles;

  @override
  void initState() {
    super.initState();

    // Register observer to detect app lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    // Initialize form values
    _selectedCategory = widget.initialCategory;
    _selectedCategoryId = widget.initialCategoryId;

    // Setup frame ticker to monitor performance
    _ticker = Ticker(_checkFrameRate);
    _ticker.start();
  }

  void _checkFrameRate(Duration elapsed) {
    // If we detect too many slow frames, reduce image processing
    if (SchedulerBinding.instance.currentFrameTimeStamp != null) {
      if (elapsed.inMilliseconds > 16) {
        // 60fps target = ~16ms per frame
        _slowFrames++;

        // If we detect consistent jank, reduce processing
        if (_slowFrames > 10 && _selectedImagePaths.length > 1) {
          if (mounted) {
            setState(() {
              // Keep only 1 image if we're experiencing performance issues
              if (_selectedImagePaths.length > 1) {
                _selectedImagePaths.removeRange(1, _selectedImagePaths.length);
                _errorMessage = 'Hiệu suất thấp, chỉ giữ lại 1 hình ảnh';
              }
            });
          }
          _slowFrames = 0;
        }
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Cancel operations if app goes to background
    if (state == AppLifecycleState.paused) {
      ProductNetwork.cancelOperations();

      // Perform cleanup when app goes to background
      if (_isSubmitting || _isProcessing) {
        _cleanupTemporaryFiles();
      }
    }
  }

  @override
  void dispose() {
    // Clean up resources
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();

    // Cancel any ongoing operations
    ProductNetwork.cancelOperations();

    // Clean up any temporary files
    _cleanupTemporaryFiles();

    super.dispose();
  }

  // Clean up temporary files to prevent file system issues
  void _cleanupTemporaryFiles() {
    for (final file in _filesToCleanup) {
      try {
        if (file.existsSync()) {
          // Just mark files for deletion, don't block UI thread
          compute(_safeDeleteFile, file.path);
        }
      } catch (e) {
        // Ignore errors during cleanup
        print('Error during file cleanup: $e');
      }
    }
    _filesToCleanup.clear();
  }

  // Static method to safely delete a file without blocking
  static Future<void> _safeDeleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Ignore errors
    }
  }

  // Image selection with improved performance
  Future<void> _pickImages() async {
    if (_isProcessing || _isSubmitting || _isUploadingInProgress) {
      _showErrorSnackBar('Đang xử lý, vui lòng đợi...');
      return;
    }

    // Check if we already have max images
    if (_selectedImagePaths.length >= _maxImages) {
      _showErrorSnackBar('Tối đa ${_maxImages} hình ảnh cho mỗi sản phẩm');
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // Use lower quality and size limits for image picking
      final List<XFile>? pickedImages = await _imagePicker.pickMultiImage(
        // Limit image quality to reduce processing
        imageQuality: 70,
        // Limit max width to reduce memory usage
        maxWidth: 800,
      );

      if (pickedImages != null && pickedImages.isNotEmpty) {
        // Only take up to max allowed images
        final imagesToProcess =
            pickedImages.length + _selectedImagePaths.length > _maxImages
                ? pickedImages.sublist(
                  0,
                  _maxImages - _selectedImagePaths.length,
                )
                : pickedImages;

        if (imagesToProcess.length < pickedImages.length) {
          _errorMessage = 'Chỉ ${_maxImages} hình ảnh được cho phép';
        }

        // Process images with frame-aware batching
        await _processSafeImageBatch(imagesToProcess);
      }
    } catch (e) {
      print('Error picking images: $e');
      _errorMessage = 'Lỗi khi chọn ảnh: ${e.toString().split('\n')[0]}';
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  // Process images while respecting frame budget
  Future<void> _processSafeImageBatch(List<XFile> pickedImages) async {
    const int batchSize =
        1; // Process one image at a time for better UI responsiveness

    for (int i = 0; i < pickedImages.length; i += batchSize) {
      if (_isSubmitting) break; // Stop processing if submitting

      final int end =
          (i + batchSize < pickedImages.length)
              ? i + batchSize
              : pickedImages.length;

      final batch = pickedImages.sublist(i, end);

      // Process images on a background thread
      await compute(
        _validateAndOptimizeImage,
        batch.map((x) => x.path).toList(),
      ).then((validPaths) {
        if (mounted && validPaths.isNotEmpty) {
          setState(() {
            for (var path in validPaths) {
              _selectedImagePaths.add(path);
            }
          });
        }
      });

      // Allow frame to complete before processing next batch
      await Future.delayed(const Duration(milliseconds: 16));
    }
  }

  // Static method for validation and optimization in isolate
  static List<String> _validateAndOptimizeImage(List<String> paths) {
    final validPaths = <String>[];

    for (var path in paths) {
      try {
        final file = File(path);
        if (file.existsSync()) {
          final fileSize = file.lengthSync();
          // Filter out very large images
          if (fileSize <= 3 * 1024 * 1024) {
            // 3MB limit
            validPaths.add(path);
          }
        }
      } catch (e) {
        print('Error validating image $path: $e');
      }
    }

    return validPaths;
  }

  void _removeImage(int index) {
    if (index >= 0 && index < _selectedImagePaths.length) {
      final path = _selectedImagePaths[index];

      setState(() {
        _selectedImagePaths.removeAt(index);
        _errorMessage = null;
      });

      // Mark file for cleanup
      try {
        final file = File(path);
        if (file.existsSync()) {
          _filesToCleanup.add(file);
        }
      } catch (e) {
        // Ignore file errors
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Prevent ViewRootImpl performance issues by using lightweight widget tree
    return WillPopScope(
      // Prevent accidental back navigation during processing
      onWillPop:
          () async =>
              !(_isSubmitting || _isProcessing || _isUploadingInProgress),
      child: AlertDialog(
        title: Text(
          'Thêm sản phẩm mới',
          style: TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 450, // Reduced for better performance
            maxHeight:
                MediaQuery.of(context).size.height * 0.7, // Reduced height
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Product form fields
                _buildProductForm(),

                SizedBox(height: 16), // Reduced space
                // Image picker section with RepaintBoundary for better performance
                RepaintBoundary(
                  key: _imagesKey,
                  child: _buildImagePickerSection(),
                ),

                // Error message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: _buildDialogActions(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Separate product form to optimize rebuilds
  Widget _buildProductForm() {
    return Column(
      children: [
        TextField(
          controller: widget.productCodeController,
          decoration: InputDecoration(
            labelText: 'Mã sản phẩm',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        SizedBox(height: 12), // Reduced space
        TextField(
          controller: widget.nameController,
          decoration: InputDecoration(
            labelText: 'Tên sản phẩm',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        SizedBox(height: 12), // Reduced space
        TextField(
          controller: widget.priceController,
          decoration: InputDecoration(
            labelText: 'Giá bán',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 12), // Reduced space
        TextField(
          controller: widget.quantityController,
          decoration: InputDecoration(
            labelText: 'Số lượng',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 12), // Reduced space
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Danh mục',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                _selectedCategoryId = '66547ffc-72db-4c1a-88b6-30697ab95495';
              } else if (value == 'Laptop') {
                _selectedCategoryId = '0a903a10-99e7-4b8a-aef0-513258404ffc';
              }
            });
          },
        ),
        SizedBox(height: 12), // Reduced space
        TextField(
          controller: widget.descriptionController,
          decoration: InputDecoration(
            labelText: 'Mô tả sản phẩm',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          maxLines: 1, // Further reduced for better performance
        ),
      ],
    );
  }

  // Separate image picker section to improve readability and performance
  Widget _buildImagePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hình ảnh sản phẩm',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.add_photo_alternate, size: 18), // Smaller icon
              label: Text(
                'Thêm ảnh (${_selectedImagePaths.length}/$_maxImages)',
              ),
              onPressed:
                  (_isProcessing ||
                          _isSubmitting ||
                          _isUploadingInProgress ||
                          _selectedImagePaths.length >= _maxImages)
                      ? null
                      : _pickImages,
            ),
          ],
        ),
        SizedBox(height: 4), // Reduced space
        // Container for images with fixed height to prevent layout shifts
        Container(
          height: 120, // Reduced height
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child:
              _isProcessing
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20, // Smaller
                          height: 20, // Smaller
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        SizedBox(height: 4), // Reduced space
                        Text(
                          'Đang xử lý ảnh...',
                          style: TextStyle(
                            color: Color(0xFF1A237E),
                            fontSize: 11, // Smaller text
                          ),
                        ),
                      ],
                    ),
                  )
                  : _selectedImagePaths.isEmpty
                  ? Center(
                    child: Text(
                      'Chưa có ảnh nào được chọn',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  )
                  : _buildEfficientImageGrid(),
        ),

        if (_selectedImagePaths.isNotEmpty && !_isProcessing)
          Padding(
            padding: const EdgeInsets.only(top: 4.0), // Reduced space
            child: Text(
              '${_selectedImagePaths.length} hình ảnh được chọn',
              style: TextStyle(
                fontSize: 11, // Smaller text
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  // Optimized image grid that renders more efficiently
  Widget _buildEfficientImageGrid() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _selectedImagePaths.length,
      cacheExtent: 250, // Reduced for better performance
      physics: ClampingScrollPhysics(), // More efficient physics
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(6.0), // Reduced padding
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.file(
                    File(_selectedImagePaths[index]),
                    fit: BoxFit.cover,
                    cacheWidth: 100, // Further reduced for better performance
                    gaplessPlayback: true, // Prevent image flickering
                    frameBuilder: (context, child, frame, _) {
                      if (frame == null) {
                        return Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: SizedBox(
                              width: 12, // Smaller indicator
                              height: 12, // Smaller indicator
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF1A237E),
                              ),
                            ),
                          ),
                        );
                      }
                      return child;
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 16,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap:
                        (_isProcessing || _isSubmitting)
                            ? null
                            : () => _removeImage(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(2), // Reduced padding
                      child: Icon(
                        Icons.close,
                        size: 10,
                        color: Colors.white,
                      ), // Smaller icon
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Actions for dialog (separated for cleaner code)
  List<Widget> _buildDialogActions() {
    return [
      TextButton(
        onPressed:
            (_isSubmitting || _isProcessing || _isUploadingInProgress)
                ? null
                : () => Navigator.pop(context),
        child: Text('Hủy', style: TextStyle(color: Colors.grey[600])),
      ),
      ElevatedButton(
        onPressed:
            (_isProcessing || _isSubmitting || _isUploadingInProgress)
                ? null
                : _submitProduct,
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1A237E)),
        child:
            _isSubmitting || _isUploadingInProgress
                ? SizedBox(
                  width: 16, // Smaller
                  height: 16, // Smaller
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                : Text('Thêm sản phẩm'),
      ),
    ];
  }

  Future<void> _submitProduct() async {
    if (_isProcessing || _isSubmitting || _isUploadingInProgress) return;

    // Validate inputs
    if (widget.productCodeController.text.isEmpty ||
        widget.nameController.text.isEmpty ||
        widget.priceController.text.isEmpty ||
        widget.quantityController.text.isEmpty) {
      _showErrorSnackBar('Vui lòng điền đầy đủ thông tin sản phẩm');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    // Create product data
    final productData = {
      'productCode': widget.productCodeController.text,
      'name': widget.nameController.text,
      'quantity': int.tryParse(widget.quantityController.text) ?? 0,
      'description': widget.descriptionController.text,
      'price': double.tryParse(widget.priceController.text) ?? 0,
      'position': 0, // Default position
      'category': {'id': _selectedCategoryId, 'name': _selectedCategory},
    };

    // Show loading indicator (simple, to avoid jank)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 12, // Smaller indicator
              height: 12, // Smaller indicator
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8), // Reduced space
            Text('Đang tạo sản phẩm mới...'),
          ],
        ),
        duration: Duration(seconds: 30),
        backgroundColor: Color(0xFF1A237E),
      ),
    );

    try {
      // Convert image paths to File objects for API call
      final List<File>? imageFiles =
          _selectedImagePaths.isNotEmpty
              ? _selectedImagePaths.map((path) => File(path)).toList()
              : null;

      // Call API to create product with images
      final result = await ProductNetwork.createProduct(
        productData,
        imageFiles,
      );

      // Dismiss any existing snackbars
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Close dialog
      Navigator.pop(widget.dialogContext);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['success'] == false
                ? 'Lỗi: ${result['message']}'
                : 'Đã thêm sản phẩm mới',
          ),
          backgroundColor:
              result['success'] == false ? Colors.red : Color(0xFF1A237E),
        ),
      );

      // Call callback to refresh product list
      widget.onProductCreated();
    } catch (e) {
      // Dismiss any existing snackbars
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Lỗi: ${e.toString().split('\n')[0]}';
      });

      // Show error message
      _showErrorSnackBar('Lỗi: ${e.toString().split('\n')[0]}');
    }
  }
}
