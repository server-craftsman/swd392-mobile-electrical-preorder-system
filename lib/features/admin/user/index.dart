import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/user_network.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/res/index.dart';
import 'package:intl/intl.dart';
import 'package:mobile_electrical_preorder_system/features/admin/user/partials/details.dart';
import 'package:mobile_electrical_preorder_system/features/admin/user/partials/sign_up.dart';

class CustomerManagePage extends StatefulWidget {
  @override
  _CustomerManagePageState createState() => _CustomerManagePageState();
}

class _CustomerManagePageState extends State<CustomerManagePage> {
  final UserNetwork _userNetwork = UserNetwork();
  List<User> _users = [];
  bool _isLoading = true;
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  String _errorMessage = '';

  // Filter settings
  String _selectedMonth = 'Tất cả';
  String _selectedRole = 'Tất cả';
  final List<String> _months = [
    'Tất cả',
    'Tháng 1',
    'Tháng 2',
    'Tháng 3',
    'Tháng 4',
    'Tháng 5',
    'Tháng 6',
    'Tháng 7',
    'Tháng 8',
    'Tháng 9',
    'Tháng 10',
    'Tháng 11',
    'Tháng 12',
  ];
  final List<String> _roles = [
    'Tất cả',
    'ROLE_ADMIN',
    'ROLE_STAFF',
    'ROLE_CUSTOMER',
  ];
  String _searchQuery = '';

  // Modern color scheme
  static const Color primaryColor = Color(0xFF1A237E); // Deep indigo
  static const Color accentColor = Color(0xFF7986CB); // Light indigo
  static const Color backgroundColor = Color(0xFFF8F9FA); // Soft white
  static const Color textPrimaryColor = Color(0xFF37474F); // Dark blue-grey
  static const Color textSecondaryColor = Color(0xFF78909C); // Light blue-grey

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Call the API with the role parameter if a specific role is selected
      final result = await _userNetwork.getAllUser(
        page: _currentPage,
        size: 10,
        role: _selectedRole != 'Tất cả' ? _selectedRole : null,
      );

      if (!mounted) return;

      setState(() {
        _users = result['users'] as List<User>;
        _totalPages = result['totalPages'] as int;
        _totalElements = result['totalElements'] as int;
        _currentPage = result['currentPage'] as int;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Không thể tải danh sách khách hàng: ${e.toString()}';
      });
    }
  }

  void _searchUsers(String query) {
    setState(() {
      _searchQuery = query;
    });
    // In a real implementation, you might want to call the API with a search parameter
    // For now, we'll just filter the local list
  }

  List<User> get _filteredUsers {
    if (_searchQuery.isEmpty && _selectedMonth == 'Tất cả') {
      return _users;
    }

    return _users.where((user) {
      // Apply search filter
      bool matchesSearch =
          _searchQuery.isEmpty ||
          user.fullname.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());

      // Apply month filter if needed
      bool matchesMonth = true;
      if (_selectedMonth != 'Tất cả') {
        // Extract month number (1-12) from the selected month string
        int monthNumber = _months.indexOf(_selectedMonth);
        if (monthNumber > 0) {
          DateTime createdDate = user.createdAt;
          matchesMonth = createdDate.month == monthNumber;
        }
      }

      return matchesSearch && matchesMonth;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
              SizedBox(height: 20),
              Text(
                'Đang tải dữ liệu...',
                style: TextStyle(
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Quản lý khách hàng',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),

        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, size: 20),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(Icons.person_add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StaffSignUpPage()),
              ).then((result) {
                if (result is Map && result['success'] == true) {
                  _fetchUsers();
                }
              });
            },
            tooltip: 'Thêm nhân viên mới',
          ),
        ),

        actions: [
          // Role filter dropdown
          Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedRole,
                dropdownColor: primaryColor,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                style: TextStyle(color: Colors.white),
                items:
                    _roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.white, size: 16),
                            SizedBox(width: 8),
                            Text(role == 'Tất cả' ? role : _getRoleText(role)),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedRole = newValue;
                      // Fetch users with the new role filter
                      _fetchUsers();
                    });
                  }
                },
              ),
            ),
          ),
          // Month filter dropdown
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedMonth,
                dropdownColor: primaryColor,
                icon: Icon(
                  Icons.filter_alt,
                  color: Colors.white,
                ), // Updated icon for a more professional look
                style: TextStyle(color: Colors.white),
                items:
                    _months.map((String month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(month),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedMonth = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryColor, primaryColor.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: _searchUsers,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm khách hàng...',
                        prefixIcon: Icon(Icons.search, color: accentColor),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: accentColor),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    if (_errorMessage.isNotEmpty) {
      return Center(
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
              'Có lỗi xảy ra',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimaryColor,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: textSecondaryColor),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchUsers,
              icon: Icon(Icons.refresh),
              label: Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final users = _filteredUsers;

    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              size: 60,
              color: textSecondaryColor.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'Không tìm thấy khách hàng nào',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Thử tìm kiếm bằng từ khóa khác'
                  : 'Không có khách hàng nào được tìm thấy',
              style: TextStyle(color: textSecondaryColor),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _fetchUsers();
      },
      color: accentColor,
      backgroundColor: Colors.white,
      strokeWidth: 3,
      displacement: 50,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _buildUserCard(user);
        },
      ),
    );
  }

  Widget _buildUserCard(User user) {
    // Format the date
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormatter.format(user.createdAt);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User header with avatar
            Row(
              children: [
                // User avatar
                user.avatar.isNotEmpty
                    ? CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user.avatar),
                      backgroundColor: accentColor.withOpacity(0.1),
                    )
                    : CircleAvatar(
                      radius: 30,
                      backgroundColor: accentColor.withOpacity(0.2),
                      child: Text(
                        _getInitials(user.fullname),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ),
                SizedBox(width: 16),

                // User name and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.fullname,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textPrimaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  user.status == 'ACTIVE'
                                      ? Color(0xFF66BB6A).withOpacity(0.2)
                                      : Color(0xFFEF5350).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  user.status == 'ACTIVE'
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  size: 12,
                                  color:
                                      user.status == 'ACTIVE'
                                          ? Color(0xFF66BB6A)
                                          : Color(0xFFEF5350),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  user.status == 'ACTIVE'
                                      ? 'Hoạt động'
                                      : 'Không hoạt động',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        user.status == 'ACTIVE'
                                            ? Color(0xFF66BB6A)
                                            : Color(0xFFEF5350),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: textSecondaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
            SizedBox(height: 16),

            // User details
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    Icons.call,
                    'Số điện thoại',
                    user.phoneNumber.isNotEmpty
                        ? user.phoneNumber
                        : 'Chưa cung cấp',
                    user.phoneNumber.isEmpty
                        ? textSecondaryColor
                        : textPrimaryColor,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    Icons.calendar_today,
                    'Ngày tham gia',
                    formattedDate,
                    textPrimaryColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    Icons.verified_user,
                    'Trạng thái xác thực',
                    user.verified ? 'Đã xác thực' : 'Chưa xác thực',
                    user.verified ? Color(0xFF66BB6A) : Color(0xFFEF5350),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    Icons.person,
                    'Vai trò',
                    _getRoleText(user.role),
                    accentColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to the user details page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsPage(userId: user.id),
                      ),
                    ).then((result) {
                      // Refresh the list if user was deleted
                      if (result is Map && result['deleted'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result['message'] ?? 'Tài khoản đã được xóa',
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        _fetchUsers();
                      }
                    });
                  },
                  icon: Icon(Icons.visibility, size: 18),
                  label: Text('Chi tiết'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    Color valueColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: textSecondaryColor),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: textSecondaryColor),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
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
}
