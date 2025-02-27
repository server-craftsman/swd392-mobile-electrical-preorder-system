import 'package:firebase_messaging/firebase_messaging.dart';
class FirebaseMessagingSetup {
  static Future<void> setupFirebaseMessaging() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      print('FCM Token: $token');
    });
  }

  // static Future<void> setupInstallationId() async {
  //   String? installationId = await FirebaseInstallations.instance.getId();
  //   print('Installation ID: $installationId');
  // }

  static Future<void> setupFirebaseMessagingBackgroundHandler() async {
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print('onBackgroundMessage: ${message.messageId}');
    });
  }

  static Future<void> setupFirebaseMessagingForegroundHandler() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('onMessage: ${message.messageId}');
    });
  }

  static Future<void> setupFirebaseMessagingNotificationSettings() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> setupFirebaseMessagingTokenRefresh() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      print('onTokenRefresh: $token');
    });
  }
}
