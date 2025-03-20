import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/res/index.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/user_network.dart';

class UserDetailsPage extends StatefulWidget {
  final String userId;

  UserDetailsPage({required this.userId});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final UserNetwork _userNetwork = UserNetwork();
  bool _isLoading = true;
  bool _isDeleting = false;
  User? _user;
  String _errorMessage = '';

  // Modern luxury color scheme
  static const Color primaryColor = Color(0xFF1A237E); // Deep indigo
  static const Color accentColor = Color(0xFF7986CB); // Light indigo
  static const Color backgroundColor = Color(0xFFF8F9FA); // Soft white
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF37474F); // Dark blue-grey
  static const Color textSecondaryColor = Color(0xFF78909C); // Light blue-grey
  static const Color dangerColor = Color(0xFFD32F2F); // More elegant red
  static const Color deleteButtonColor = Color(0xFFB71C1C); // Deep elegant red

  // Store reference to scaffold messenger for snackbars
  late ScaffoldMessengerState _scaffoldMessenger;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  Future<void> _fetchUserDetails() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = await _userNetwork.getUserById(widget.userId);

      if (!mounted) return;

      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Không thể tải thông tin người dùng: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text('Chi tiết người dùng'),
          backgroundColor: primaryColor,
        ),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text('Chi tiết người dùng'),
          backgroundColor: primaryColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 70, color: dangerColor),
              SizedBox(height: 20),
              Text(
                'Đã xảy ra lỗi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textPrimaryColor,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textSecondaryColor),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _fetchUserDetails,
                icon: Icon(Icons.refresh),
                label: Text('Thử lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_user == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text('Chi tiết người dùng'),
          backgroundColor: primaryColor,
        ),
        body: Center(
          child: Text(
            'Không tìm thấy thông tin người dùng',
            style: TextStyle(color: textSecondaryColor),
          ),
        ),
      );
    }

    // Format date
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
    final formattedCreatedAt = dateFormatter.format(_user!.createdAt);
    final formattedUpdatedAt = dateFormatter.format(_user!.updatedAt);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            slivers: [
              // App bar with user avatar
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                backgroundColor: primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [primaryColor, accentColor],
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Decorative circles
                        Positioned(
                          top: -50,
                          right: -50,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -20,
                          left: -30,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),

                        // User avatar and name
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Avatar
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child:
                                      _user!.avatar.isNotEmpty
                                          ? Image.network(
                                            _user!.avatar,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Container(
                                                color: accentColor.withOpacity(
                                                  0.3,
                                                ),
                                                child: Icon(
                                                  Icons.person,
                                                  size: 50,
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                          )
                                          : Container(
                                            color: accentColor.withOpacity(0.3),
                                            child: Center(
                                              child: Text(
                                                _getInitials(_user!.fullname),
                                                style: TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                ),
                              ),
                              SizedBox(height: 16),
                              // Name
                              Text(
                                _user!.fullname,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              // Status badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      _user!.status == 'ACTIVE'
                                          ? Colors.green.withOpacity(0.8)
                                          : dangerColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _user!.status == 'ACTIVE'
                                      ? 'Hoạt động'
                                      : 'Không hoạt động',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // User information
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic information card
                      _buildInfoCard('Thông tin cơ bản', Icons.person, [
                        _buildInfoRow('Email', _user!.email),
                        _buildInfoRow('Tên đăng nhập', _user!.username),
                        _buildInfoRow(
                          'Số điện thoại',
                          _user!.phoneNumber.isNotEmpty
                              ? _user!.phoneNumber
                              : 'Chưa cung cấp',
                        ),
                        _buildInfoRow('Vai trò', _getRoleText(_user!.role)),
                      ]),

                      SizedBox(height: 16),

                      // Account status card
                      _buildInfoCard(
                        'Trạng thái tài khoản',
                        Icons.verified_user,
                        [
                          _buildInfoRow(
                            'Xác thực',
                            _user!.verified ? 'Đã xác thực' : 'Chưa xác thực',
                            valueColor:
                                _user!.verified ? Colors.green : dangerColor,
                          ),
                          _buildInfoRow(
                            'Trạng thái',
                            _user!.status == 'ACTIVE'
                                ? 'Đang hoạt động'
                                : 'Không hoạt động',
                            valueColor:
                                _user!.status == 'ACTIVE'
                                    ? Colors.green
                                    : dangerColor,
                          ),
                          _buildInfoRow(
                            'Đã xóa',
                            _user!.deleted ? 'Đã xóa' : 'Chưa xóa',
                            valueColor:
                                !_user!.deleted ? Colors.green : dangerColor,
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Dates card
                      _buildInfoCard('Thời gian', Icons.access_time, [
                        _buildInfoRow('Ngày tạo', formattedCreatedAt),
                        _buildInfoRow('Cập nhật lần cuối', formattedUpdatedAt),
                      ]),

                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Loading overlay
          if (_isDeleting)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton:
          _user != null
              ? Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: deleteButtonColor.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: FloatingActionButton.extended(
                  heroTag: "userDetailsDeleteButton",
                  onPressed: () => _showDeleteConfirmation(),
                  backgroundColor: deleteButtonColor,
                  elevation:
                      0, // Remove default elevation since we have custom shadow
                  icon: Icon(
                    Icons.delete_outline_rounded, // More elegant icon
                    color: Colors.white,
                  ),
                  label: Text(
                    'Xóa tài khoản này',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              )
              : null,
    );
  }

  Widget _buildInfoCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accentColor, size: 24),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: valueColor ?? textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        deleteButtonColor.withOpacity(0.8),
                        deleteButtonColor,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Xác nhận xóa tài khoản',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textPrimaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Bạn có chắc chắn muốn xóa tài khoản của ${_user!.fullname}?',
                        style: TextStyle(
                          fontSize: 16,
                          color: textPrimaryColor,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Hành động này không thể hoàn tác và tất cả dữ liệu của người dùng sẽ bị mất.',
                        style: TextStyle(
                          fontSize: 14,
                          color: textSecondaryColor,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: TextButton.styleFrom(
                          foregroundColor: textSecondaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Hủy',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              deleteButtonColor,
                              Color(0xFF8B0000), // Darker shade for gradient
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: deleteButtonColor.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            _deleteUser();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Xóa tài khoản',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _deleteUser() async {
    if (!mounted) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      final result = await _userNetwork.deleteUser(_user!.id);

      if (!mounted) return;

      setState(() {
        _isDeleting = false;
      });

      if (result['success'] == true) {
        // Return result to previous screen and close this one
        Navigator.of(context).pop({
          'deleted': true,
          'message': result['message'] ?? 'Tài khoản đã được xóa thành công',
        });
      } else {
        // Show error message
        _scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Không thể xóa tài khoản'),
            backgroundColor: dangerColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isDeleting = false;
      });

      _scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: dangerColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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

  String _getRoleText(String role) {
    switch (role.toUpperCase()) {
      case 'ROLE_ADMIN':
        return 'Quản trị viên';
      case 'ROLE_CUSTOMER':
        return 'Khách hàng';
      case 'ROLE_MANUFACTURER':
        return 'Nhà sản xuất';
      default:
        return role;
    }
  }
}
