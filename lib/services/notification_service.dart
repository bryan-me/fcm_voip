import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService() {
    final androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Use DarwinInitializationSettings for iOS/macOS initialization
    final darwinInitSettings = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: darwinInitSettings,  // Correct parameter name for iOS
    );

    _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    final androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.high,
      priority: Priority.high,
    );

    // Use DarwinNotificationDetails for iOS/macOS
    final darwinDetails = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,  // Correct parameter name for iOS
    );

    await _notificationsPlugin.show(0, title, body, notificationDetails);
  }
}