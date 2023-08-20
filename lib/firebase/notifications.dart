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

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(settings);

    // Když bych chtěl při kliknutí na notifikaci načíst nějakou specifickou stránku
    /*await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload));
      handleMessage
    });*/

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

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
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> getFCMToken() async {
    final fCMToken = await _firebaseMessaging.getToken();
    _fCMTokenService.saveFCMToken(FCMToken(id: "", token: fCMToken!));
  }

  /*Future<void> notifyRecipient(
      {String? token, required String body, required String title}) async {
    final dio = Dio();

    try {
      await dio.postUri(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        options: Options(
          headers: {
            'content-Type': 'application/json',
            'authorization':
                'key=AAAA143Z3GY:APA91bG75lcmy0KGaNX2w03lZrOUj5qxOw5u0mMEfyLJN_6EV8MIp1gIAk94AjD9wsgMjz1YJe1amIlISBmwQrrdjeF1SXW67O717Yosm6SSkV-NAjQTXG10JQJiuRC8Fcu_KQyK1MD3'
          },
        ),
        data: {
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': body,
            'title': title,
          },
          'notification': {
            'title': title,
            'body': body,
            'android_channel_id': 'high_importance_channel',
          },
          'to': token,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }*/
}
