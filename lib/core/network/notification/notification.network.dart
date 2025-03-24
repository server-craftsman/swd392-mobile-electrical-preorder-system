import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';

class NotificationNetwork {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getNotificationList() async {
    final response = await _apiClient.get('/notifications');
    return response.data;
  }

  // Add method to get notifications for a specific user
  Future<Map<String, dynamic>> getNotificationsByUserId(
    String userId, {
    int page = 0,
    int size = 10,
  }) async {
    final response = await _apiClient.get(
      '/notifications/$userId',
      queryParameters: {'page': page, 'size': size},
    );

    return response.data;
  }

  // You might also want a method to mark notifications as read
  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      final response = await _apiClient.put(
        '/notifications/$notificationId/read',
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  // Optional: Method to get notification count (unread)
  Future<int> getUnreadNotificationCount(String userId) async {
    try {
      final response = await _apiClient.get(
        '/notifications/$userId/unread/count',
      );
      return response.data['count'] ?? 0;
    } catch (e) {
      print('Error getting unread notification count: $e');
      return 0;
    }
  }
}
