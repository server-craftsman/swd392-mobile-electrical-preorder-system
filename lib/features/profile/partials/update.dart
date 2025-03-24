import 'package:flutter/material.dart';
import 'dart:io';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/user_network.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/res/index.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileUpdatePage extends StatefulWidget {
  final String? userId;
  final User? user;
  final Function? onProfileUpdated;

  UserProfileUpdatePage({this.userId, this.user, this.onProfileUpdated});

  @override
  _UserProfileUpdatePageState createState() => _UserProfileUpdatePageState();
}

class _UserProfileUpdatePageState extends State<UserProfileUpdatePage> {
  final UserNetwork _userNetwork = UserNetwork();
  final ImagePicker _imagePicker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingUser = false;
  String? _errorMessage;
  User? _user;
  File? _selectedAvatar;
  bool _isUploadingImage = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _initializeUserData();
  }

  @override
  void dispose() {
    // Clean up controllers
    _fullnameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();

    // Cancel any ongoing operations
    _userNetwork.cancelOperations();
    super.dispose();
  }

  Future<void> _initializeUserData() async {
    if (_user != null) {
      _populateFields(_user!);
      return;
    }

    setState(() {
      _isLoadingUser = true;
    });

    try {
      String? userId = widget.userId;

      // If userId is not provided, get it from token
      if (userId == null) {
        final accessToken = await TokenService.getAccessToken();
        if (accessToken != null) {
          final decodedToken = await TokenService.decodeAccessToken(
            accessToken,
          );
          userId = decodedToken?['id'];
        }
      }

      if (userId == null) {
        setState(() {
          _isLoadingUser = false;
          _errorMessage = 'Không thể xác định người dùng';
        });
        return;
      }

      _userId = userId;

      // Get user details from API
      final user = await _userNetwork.getUserById(userId);

      if (mounted) {
        setState(() {
          _user = user;
          _isLoadingUser = false;
          if (user != null) {
            _populateFields(user);
          } else {
            _errorMessage = 'Không tìm thấy thông tin người dùng';
          }
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
      if (mounted) {
        setState(() {
          _isLoadingUser = false;
          _errorMessage =
              'Không thể tải thông tin người dùng: ${e.toString().split('\n')[0]}';
        });
      }
    }
  }

  void _populateFields(User user) {
    _fullnameController.text = user.fullname;
    _phoneNumberController.text = user.phoneNumber;
    _addressController.text = user.address;
  }

  Future<void> _pickImage() async {
    if (_isUploadingImage) {
      _showSnackBar('Đang xử lý ảnh, vui lòng đợi...', isError: true);
      return;
    }

    setState(() {
      _isUploadingImage = true;
    });

    try {
      final XFile? pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedImage != null) {
        final imageFile = File(pickedImage.path);

        // Validate file size (max 3MB)
        final fileSize = await imageFile.length();
        if (fileSize > 3 * 1024 * 1024) {
          _showSnackBar(
            'Ảnh quá lớn (${(fileSize / (1024 * 1024)).toStringAsFixed(2)}MB). Giới hạn: 3MB.',
            isError: true,
          );
          return;
        }

        // Validate file exists
        if (!await imageFile.exists()) {
          _showSnackBar('Không thể đọc tệp ảnh', isError: true);
          return;
        }

        print('Selected image: ${imageFile.path}, size: ${fileSize} bytes');

        setState(() {
          _selectedAvatar = imageFile;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      _showSnackBar(
        'Không thể chọn ảnh: ${e.toString().split('\n')[0]}',
        isError: true,
      );
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_isLoading) return;

    if (_formKey.currentState?.validate() != true) {
      return;
    }

    // Get current user ID
    if (_userId == null && _user?.id == null) {
      _showSnackBar('Không thể xác định người dùng', isError: true);
      return;
    }

    final userId = _userId ?? _user!.id;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Prepare user data according to API structure
      final userData = {
        'fullname': _fullnameController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'address': _addressController.text.trim(),
      };

      print('Sending update with data: $userData');

      // Validate avatar if selected
      if (_selectedAvatar != null) {
        if (!await _selectedAvatar!.exists()) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Tệp ảnh không tồn tại hoặc không thể đọc';
          });
          _showSnackBar(_errorMessage!, isError: true);
          return;
        }

        final fileSize = await _selectedAvatar!.length();
        final fileName = _selectedAvatar!.path.split('/').last;
        final extension = fileName.split('.').last.toLowerCase();

        print('Sending avatar file: ${_selectedAvatar!.path}');
        print(
          'File details: Name=$fileName, Size=${fileSize} bytes, Type=$extension',
        );

        if (fileSize > 3 * 1024 * 1024) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Ảnh đại diện vượt quá kích thước cho phép (3MB)';
          });
          _showSnackBar(_errorMessage!, isError: true);
          return;
        }

        // Check valid image extension
        if (!['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
          setState(() {
            _isLoading = false;
            _errorMessage =
                'Định dạng ảnh không được hỗ trợ. Vui lòng sử dụng JPG, PNG, GIF hoặc WEBP';
          });
          _showSnackBar(_errorMessage!, isError: true);
          return;
        }
      }

      // Update profile with or without avatar
      final result = await _userNetwork.updateUserProfile(
        userId: userId,
        userData: userData,
        avatarImage: _selectedAvatar,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Check for server error (500)
        if (result.containsKey('errorCode') && result['errorCode'] == 500) {
          _errorMessage = 'Lỗi máy chủ (500): ${result['message']}';
          _showSnackBar(_errorMessage!, isError: true);

          // Show more detailed error dialog for developers
          _showServerErrorDialog(result['serverMessage']);
          return;
        }

        if (result['success'] == true) {
          _showSnackBar(result['message'] ?? 'Cập nhật thành công');

          // If avatar was updated, refresh the user data to get the new avatar URL
          if (_selectedAvatar != null) {
            print('Avatar updated successfully, refreshing user data');
            // Re-initialize user data to fetch the updated avatar
            _initializeUserData();
          }

          // Notify parent about the update if callback is provided
          if (widget.onProfileUpdated != null) {
            widget.onProfileUpdated!();
          }

          // Go back to previous screen after a short delay
          Future.delayed(Duration(seconds: 1), () {
            if (mounted) {
              Navigator.of(
                context,
              ).pop(true); // Pass true to indicate successful update
            }
          });
        } else {
          _errorMessage = result['message'];

          // Handle specific avatar upload errors
          if (_errorMessage != null && _errorMessage!.contains('ảnh')) {
            _showImageErrorDialog(_errorMessage!);
          } else {
            _showSnackBar(_errorMessage ?? 'Cập nhật thất bại', isError: true);
          }
        }
      }
    } catch (e) {
      print('Error updating profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Lỗi cập nhật: ${e.toString().split('\n')[0]}';
        });
        _showSnackBar(_errorMessage!, isError: true);
      }
    }
  }

  void _showServerErrorDialog(String? errorDetails) {
    if (errorDetails == null || !mounted) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Lỗi Máy Chủ (500)',
              style: TextStyle(color: Colors.red),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chi tiết lỗi từ máy chủ:'),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Text(
                      errorDetails,
                      style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Vui lòng chụp màn hình này và gửi cho đội phát triển để được hỗ trợ.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Đóng'),
              ),
            ],
          ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Color(0xFF1A237E),
        duration: Duration(seconds: isError ? 3 : 2),
      ),
    );
  }

  void _showImageErrorDialog(String errorMessage) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Lỗi khi cập nhật ảnh',
              style: TextStyle(color: Colors.red),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Không thể cập nhật ảnh đại diện vì:'),
                SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Vui lòng kiểm tra các điều kiện sau:',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bulletPoint('Kích thước ảnh < 3MB'),
                    _bulletPoint('Định dạng: JPG, PNG, GIF hoặc WEBP'),
                    _bulletPoint('Ảnh không bị hỏng hoặc mất dữ liệu'),
                    _bulletPoint('Thử chọn một ảnh khác'),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Remove the selected avatar to allow user to try again
                  setState(() {
                    _selectedAvatar = null;
                  });
                },
                child: Text('Thử lại'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Đóng'),
              ),
            ],
          ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';

    List<String> nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return nameParts.first[0].toUpperCase() + nameParts.last[0].toUpperCase();
    } else {
      return nameParts.first[0].toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Cập nhật thông tin',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Color(0xFF1A237E),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:
          _isLoadingUser
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A237E)),
                ),
              )
              : _errorMessage != null && _user == null
              ? _buildErrorView()
              : _buildForm(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red.withOpacity(0.8),
            ),
            SizedBox(height: 16),
            Text(
              'Lỗi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _initializeUserData,
              icon: Icon(Icons.refresh),
              label: Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1A237E),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar selection
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Color(0xFF1A237E).withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF1A237E).withOpacity(0.3),
                              width: 3,
                            ),
                          ),
                          child:
                              _selectedAvatar != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.file(
                                      _selectedAvatar!,
                                      fit: BoxFit.cover,
                                      width: 120,
                                      height: 120,
                                    ),
                                  )
                                  : _user != null && _user!.avatar.isNotEmpty
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.network(
                                      _user!.avatar,
                                      fit: BoxFit.cover,
                                      width: 120,
                                      height: 120,
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                            strokeWidth: 2,
                                            color: Color(0xFF1A237E),
                                          ),
                                        );
                                      },
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Center(
                                          child: Text(
                                            _getInitials(
                                              _fullnameController.text,
                                            ),
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1A237E),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                  : Center(
                                    child: Text(
                                      _getInitials(_fullnameController.text),
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A237E),
                                      ),
                                    ),
                                  ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Color(0xFF1A237E),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        if (_isUploadingImage)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 3,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Chạm để thay đổi ảnh đại diện',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Form fields
            Text(
              'Thông tin cá nhân',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            SizedBox(height: 16),

            // Fullname field
            TextFormField(
              controller: _fullnameController,
              decoration: InputDecoration(
                labelText: 'Họ và tên',
                hintText: 'Nhập họ và tên của bạn',
                prefixIcon: Icon(Icons.person, color: Color(0xFF1A237E)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập họ tên';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Phone number field
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                hintText: 'Nhập số điện thoại của bạn',
                prefixIcon: Icon(Icons.phone, color: Color(0xFF1A237E)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),

            // Address field
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Địa chỉ',
                hintText: 'Nhập địa chỉ của bạn',
                prefixIcon: Icon(Icons.location_on, color: Color(0xFF1A237E)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 32),

            // Update button
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A237E),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 3,
                ),
                child:
                    _isLoading
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Đang cập nhật...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                        : Text(
                          'Cập nhật thông tin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),

            // Show error message if exists
            if (_errorMessage != null && _user != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
