import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/network/notification/notification.network.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationNetwork _notificationNetwork = NotificationNetwork();
  List<dynamic> _notifications = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _userId = '';
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isDisposed = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getUserIdAndLoadNotifications();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_currentPage < _totalPages - 1) {
        _loadMoreNotifications();
      }
    }
  }

  Future<void> _getUserIdAndLoadNotifications() async {
    if (!mounted || _isDisposed) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final accessToken = await TokenService.getAccessToken();
      if (accessToken != null) {
        final decodedToken = await TokenService.decodeAccessToken(accessToken);
        if (decodedToken != null && decodedToken.containsKey('id')) {
          _userId = decodedToken['id'].toString();
          await _loadNotifications();
        } else {
          throw Exception('User ID not found in token');
        }
      } else {
        throw Exception('Access token not found');
      }
    } catch (e) {
      if (!mounted || _isDisposed) return;

      setState(() {
        _errorMessage = 'Error loading notifications: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadNotifications() async {
    if (_userId.isEmpty || !mounted || _isDisposed) return;

    try {
      final response = await _notificationNetwork.getNotificationsByUserId(
        _userId,
        page: _currentPage,
        size: 10,
      );

      if (!mounted || _isDisposed) return;

      setState(() {
        _notifications = response['content'] ?? [];
        _totalPages = response['totalPages'] ?? 1;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted || _isDisposed) return;

      setState(() {
        _errorMessage = 'Failed to load notifications: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreNotifications() async {
    if (_isLoading || _userId.isEmpty || !mounted || _isDisposed) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final response = await _notificationNetwork.getNotificationsByUserId(
        _userId,
        page: nextPage,
        size: 10,
      );

      if (!mounted || _isDisposed) return;

      setState(() {
        _notifications.addAll(response['content'] ?? []);
        _currentPage = nextPage;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted || _isDisposed) return;

      setState(() {
        _errorMessage = 'Failed to load more notifications: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshNotifications() async {
    if (!mounted || _isDisposed) return;

    setState(() {
      _currentPage = 0;
      _notifications = [];
    });

    await _loadNotifications();
  }

  Future<void> _markAsRead(String notificationId) async {
    if (!mounted || _isDisposed) return;

    try {
      final result = await _notificationNetwork.markNotificationAsRead(
        notificationId,
      );
      if (result) {
        // Update the local notification list
        setState(() {
          final index = _notifications.indexWhere(
            (n) => n['id'] == notificationId,
          );
          if (index != -1) {
            _notifications[index]['read'] = true;
          }
        });
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Vừa xong';
          }
          return '${difference.inMinutes} phút trước';
        }
        return '${difference.inHours} giờ trước';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} ngày trước';
      } else {
        return DateFormat('dd/MM/yyyy').format(dateTime);
      }
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông báo',
          style: TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF1A237E)),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      body:
          _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : RefreshIndicator(
                onRefresh: _refreshNotifications,
                color: Color(0xFF1A237E),
                child:
                    _notifications.isEmpty && !_isLoading
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_off_outlined,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Bạn chưa có thông báo nào',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(16),
                          itemCount:
                              _notifications.length + (_isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _notifications.length) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final notification = _notifications[index];
                            final bool isRead = notification['read'] ?? false;

                            return Card(
                              elevation: 1,
                              margin: EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color:
                                      isRead
                                          ? Colors.transparent
                                          : Color(0xFF1A237E).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  // Mark as read when tapped
                                  if (!isRead) {
                                    _markAsRead(notification['id']);
                                  }

                                  // Handle notification tap (navigate to relevant screen)
                                  // This depends on your notification types
                                  if (notification['type'] == 'ORDER') {
                                    // Navigate to order details
                                    // Navigator.push(...);
                                  } else if (notification['type'] ==
                                      'PRODUCT') {
                                    // Navigate to product details
                                    // Navigator.push(...);
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Notification icon
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: _getNotificationColor(
                                            notification['type'],
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            _getNotificationIcon(
                                              notification['type'],
                                            ),
                                            color: _getNotificationColor(
                                              notification['type'],
                                            ),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),

                                      // Notification content
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    notification['title'] ??
                                                        'Thông báo',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          isRead
                                                              ? FontWeight
                                                                  .normal
                                                              : FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                                if (!isRead)
                                                  Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF1A237E),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              notification['message'] ?? '',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                                height: 1.3,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              _formatDate(
                                                notification['createdAt'] ?? '',
                                              ),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
    );
  }

  Color _getNotificationColor(String? type) {
    switch (type) {
      case 'ORDER':
        return Colors.orange;
      case 'PRODUCT':
        return Colors.green;
      case 'CAMPAIGN':
        return Colors.purple;
      case 'USER':
        return Colors.blue;
      default:
        return Color(0xFF1A237E);
    }
  }

  IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'ORDER':
        return Icons.receipt;
      case 'PRODUCT':
        return Icons.shopping_cart;
      case 'CAMPAIGN':
        return Icons.campaign;
      case 'USER':
        return Icons.person;
      default:
        return Icons.notifications;
    }
  }
}
