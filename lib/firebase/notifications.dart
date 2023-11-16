import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/models/fcm_token.dart';
import 'package:zachranobed/services/fcm_token_service.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Data: ${message.data}');
}

class Notifications {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  final _fCMTokenService = GetIt.I<FCMTokenService>();

  /// Initializes local notifications for the application.
  ///
  /// Configures the settings for local notifications, initializes the local
  /// notifications plugin with the specified settings, and creates a
  /// notification channel for Android.
  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(settings);

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  /// Initializes push notifications for the application.
  ///
  /// Sets foreground notification presentation options and registers callbacks
  /// for handling background messages and incoming messages. In the foreground,
  /// it displays local notifications based on the received FCM messages.
  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;
      if (notification == null) return;

      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@mipmap/launcher_icon',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  /// Initializes both push notifications and local notifications for the
  /// application.
  ///
  /// Prompts the user for notification permissions, then initializes both push
  /// notifications and local notifications by calling the corresponding
  /// initialization methods.
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    initPushNotifications();
    initLocalNotifications();
  }

  /// Retrieves and saves the FCM token for the device.
  Future<void> getFCMToken() async {
    final fCMToken = await _firebaseMessaging.getToken();
    _fCMTokenService.saveFCMToken(FCMToken(id: "", token: fCMToken!));
  }
}
