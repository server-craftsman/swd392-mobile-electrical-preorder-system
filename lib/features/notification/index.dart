import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationPage extends StatelessWidget {
  static const String route = '/notification'; // Định nghĩa route

  final RemoteMessage? message;

  const NotificationPage({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy dữ liệu từ arguments nếu không truyền trực tiếp qua constructor
    final RemoteMessage? msg =
        ModalRoute.of(context)?.settings.arguments as RemoteMessage?;

    final notification = message?.notification ?? msg?.notification;
    final data = message?.data ?? msg?.data;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification != null) ...[
              Text(
                notification.title ?? 'No Title',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                notification.body ?? 'No Body',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
            if (data != null && data.isNotEmpty) ...[
              const Text(
                'Additional Data:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(data.toString(), style: const TextStyle(fontSize: 14)),
            ],
            if (notification == null && data == null)
              const Text(
                'No notification data available.',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
