import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/user_network.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/res/index.dart';
import 'package:intl/intl.dart';
import 'package:mobile_electrical_preorder_system/features/profile/partials/update.dart';

class UserProfileDetailsPage extends StatefulWidget {
  final String? userId;

  UserProfileDetailsPage({this.userId});

  @override
  _UserProfileDetailsPageState createState() => _UserProfileDetailsPageState();
}

class _UserProfileDetailsPageState extends State<UserProfileDetailsPage> {
  User? _user;
  bool _isLoading = true;
  String? _errorMessage;
  final UserNetwork _userNetwork = UserNetwork();

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String? userId = widget.userId;

      // Nếu không có userId được truyền vào, lấy từ token
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
          _isLoading = false;
          _errorMessage = 'Không thể xác định người dùng';
        });
        return;
      }

      // Gọi API để lấy thông tin chi tiết của người dùng
      final user = await _userNetwork.getUserById(userId);

      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Không thể tải thông tin người dùng: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _navigateToUpdateProfile() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => UserProfileUpdatePage(
              userId: widget.userId,
              user: _user,
              onProfileUpdated: () {
                // This will be called when the profile is updated
                if (mounted) {
                  _loadUserDetails();
                }
              },
            ),
      ),
    );

    // If result is true, it means profile was updated
    if (result == true) {
      _loadUserDetails();
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _getRoleText(String role) {
    switch (role.toUpperCase()) {
      case 'ROLE_ADMIN':
        return 'Quản trị viên';
      case 'ROLE_CUSTOMER':
        return 'Khách hàng';
      case 'ROLE_STAFF':
        return 'Nhân viên';
      default:
        return role;
    }
  }

  String _getStatusText(String status) {
    return status.toUpperCase() == 'ACTIVE' ? 'Hoạt động' : 'Không hoạt động';
  }

  Color _getStatusColor(String status) {
    return status.toUpperCase() == 'ACTIVE'
        ? Color(0xFF66BB6A)
        : Color(0xFFEF5350);
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
          'Thông tin chi tiết',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Color(0xFF1A237E),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (_user != null)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: _navigateToUpdateProfile,
              tooltip: 'Cập nhật thông tin',
            ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadUserDetails,
          color: Color(0xFF1A237E),
          backgroundColor: Colors.white,
          strokeWidth: 3,
          displacement: 50,
          child:
              _isLoading
                  ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF1A237E),
                      ),
                    ),
                  )
                  : _errorMessage != null
                  ? Center(
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
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadUserDetails,
                            icon: Icon(Icons.refresh),
                            label: Text('Thử lại'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1A237E),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Profile Card
                        Card(
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                // Avatar
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFF1A237E).withOpacity(0.2),
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child:
                                      _user != null && _user!.avatar.isNotEmpty
                                          ? CircleAvatar(
                                            radius: 60,
                                            backgroundImage: NetworkImage(
                                              _user!.avatar,
                                            ),
                                            backgroundColor: Color(
                                              0xFF1A237E,
                                            ).withOpacity(0.1),
                                          )
                                          : CircleAvatar(
                                            radius: 60,
                                            backgroundColor: Color(
                                              0xFF1A237E,
                                            ).withOpacity(0.2),
                                            child: Text(
                                              _getInitials(
                                                _user?.fullname ?? '',
                                              ),
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1A237E),
                                              ),
                                            ),
                                          ),
                                ),
                                SizedBox(height: 16),

                                // User name
                                Text(
                                  _user?.fullname ?? 'Không rõ',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A237E),
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                SizedBox(height: 8),

                                // Status badge
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      _user?.status ?? '',
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _getStatusColor(
                                        _user?.status ?? '',
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _user?.status.toUpperCase() == 'ACTIVE'
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        size: 16,
                                        color: _getStatusColor(
                                          _user?.status ?? '',
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        _getStatusText(_user?.status ?? ''),
                                        style: TextStyle(
                                          color: _getStatusColor(
                                            _user?.status ?? '',
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 8),

                                // Role badge
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1A237E).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.badge,
                                        size: 16,
                                        color: Color(0xFF1A237E),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        _getRoleText(_user?.role ?? ''),
                                        style: TextStyle(
                                          color: Color(0xFF1A237E),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Contact Information
                        Card(
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Thông tin liên hệ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                                SizedBox(height: 16),
                                _buildInfoItem(
                                  icon: Icons.email,
                                  title: 'Email',
                                  value: _user?.email ?? 'Chưa cung cấp',
                                ),
                                SizedBox(height: 12),
                                _buildInfoItem(
                                  icon: Icons.phone,
                                  title: 'Số điện thoại',
                                  value:
                                      _user?.phoneNumber.isNotEmpty == true
                                          ? _user!.phoneNumber
                                          : 'Chưa cung cấp',
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Account Information
                        Card(
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Thông tin tài khoản',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                                SizedBox(height: 16),
                                _buildInfoItem(
                                  icon: Icons.calendar_today,
                                  title: 'Ngày tham gia',
                                  value:
                                      _user != null
                                          ? _formatDate(_user!.createdAt)
                                          : 'Không rõ',
                                ),
                                SizedBox(height: 12),
                                _buildInfoItem(
                                  icon: Icons.verified_user,
                                  title: 'Trạng thái xác thực',
                                  value:
                                      _user?.verified == true
                                          ? 'Đã xác thực'
                                          : 'Chưa xác thực',
                                  valueColor:
                                      _user?.verified == true
                                          ? Color(0xFF66BB6A)
                                          : Color(0xFFEF5350),
                                ),
                                SizedBox(height: 12),
                                _buildInfoItem(
                                  icon: Icons.lock,
                                  title: 'Mã tài khoản',
                                  value: _user?.id ?? 'Không rõ',
                                  isSelectable: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
    bool isSelectable = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF1A237E).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Color(0xFF1A237E), size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              isSelectable
                  ? SelectableText(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: valueColor ?? Colors.black87,
                    ),
                  )
                  : Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: valueColor ?? Colors.black87,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
