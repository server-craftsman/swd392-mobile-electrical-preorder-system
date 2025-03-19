import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    "high_importance_channel",
    "High Importance Notifications",
    description: "This channel is used for important notifications",
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      '/notification', // Route của NotificationPage
      arguments: message, // Truyền dữ liệu thông báo
    );
  }

  Future<void> initPushNotification() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload == null) return; // Kiểm tra nếu payload null
        final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
        handleMessage(message);
      },
    );
    final platform =
        _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initNotification() async {
    // 1️⃣ Yêu cầu quyền nhận thông báo từ người dùng
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print("User denied notification permissions.");
      return;
    }

    // 2️⃣ Xóa token cũ trước khi lấy token mới (Quan trọng)
    // await _firebaseMessaging.deleteToken();

    // 3️⃣ Lấy token mới từ Firebase
    final String? newFcmToken = await _firebaseMessaging.getToken();
    print("🔥 New FCM Token: $newFcmToken");

    // 4️⃣ Kiểm tra nếu token mới null thì thử lại sau 5 giây
    if (newFcmToken == null) {
      Future.delayed(Duration(seconds: 5), () async {
        final retryToken = await _firebaseMessaging.getToken();
        print("🔁 Retried FCM Token: $retryToken");
      });
    }

    // 5️⃣ Lấy Installation ID
    final String? installationId = await FirebaseInstallations.instance.getId();
    print("🔥 Installation ID: $installationId");

    // 6️⃣ Khởi tạo lắng nghe thông báo
    await initPushNotification();
    await initLocalNotifications();
  }
}
