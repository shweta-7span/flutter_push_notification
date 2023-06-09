import 'dart:io';
import 'dart:math';

import 'package:demo_push_notification/model/push_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'model/push_notification.dart';

class FCMHelper {
  FCMHelper._();

  static final FCMHelper _fcmHelper = FCMHelper._();

  factory FCMHelper() {
    return _fcmHelper;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // For show the notification when App is in FG.
  static const AndroidNotificationDetails _androidNotificationDetails =
  AndroidNotificationDetails(
    '1',
    'FCM Push',
    channelDescription:
    "This channel is responsible for all the local notifications",
    ticker: 'ticker',
    icon: "mipmap/ic_launcher",
    playSound: true,
    autoCancel: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  static const DarwinNotificationDetails _iOSNotificationDetails =
  DarwinNotificationDetails();

  NotificationDetails notificationDetails = const NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _iOSNotificationDetails,
  );

  init() async {
    // To handle messages whilst the app is in the background or terminated,`
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("FirebaseMessaging.onMessage message: ${message.data}");
      if (Platform.isAndroid) {
        PushNotification pushNotification = PushNotification.fromJson(message);
        debugPrint(
            "FirebaseMessaging.onMessage pushNotification.data: ${pushNotification.data}");
        if (pushNotification.data != null) {
          debugPrint('showNotification');
          showNotification(pushNotification.data!, Random().nextInt(100));
        } else {
          debugPrint('pushNotification.data is NULL');
        }
      }
    });
  }

  // For show the notification when App is in FG. In BG and Killed state no need to call.
  // Firebase automatically show in those case.
  Future<void> showNotification(PushData pushNotificationData, int id) async {
    debugPrint('id: $id');
    debugPrint('dataTitle: ${pushNotificationData.dataTitle}');
    debugPrint('dataBody: ${pushNotificationData.dataBody}');

    await flutterLocalNotificationsPlugin.show(
        id,
        pushNotificationData.dataTitle,
        pushNotificationData.dataBody,
        notificationDetails,
        payload: pushNotificationData.dataRedirect);

    debugPrint('showNotification completed');
  }
}