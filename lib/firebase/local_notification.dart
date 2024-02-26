import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
    FlutterLocalNotificationsPlugin();
final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();
Future<void> requestNotificationPermission(
    FlutterLocalNotificationsPlugin plugin) async {
  //ONly for android
  if (Platform.isAndroid) {
    final androidImplement = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImplement?.requestNotificationsPermission();
  }
}

Future<bool> isAndroidPermissionGranted(
    FlutterLocalNotificationsPlugin plugin) async {
  if (Platform.isAndroid) {
    return await plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;
  }
  return false;
}

@pragma('vn:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  //TODO: tap notification from background
}
Future<void> showNotification(
    RemoteMessage message, FlutterLocalNotificationsPlugin plugin) async {
  const detail = AndroidNotificationDetails("BUSMATE", "BUSMATE_TEXT",
      channelDescription: "description",
      importance: Importance.max,
      priority: Priority.high,
      ticker: "ticker");
  const notificationDetails = NotificationDetails(android: detail);
  await plugin.show(Random().nextInt(1000), message?.notification?.title ?? "",
      message?.notification?.body ?? " ", notificationDetails,
      payload: jsonEncode(message.data));
}

Future<void> initLocalNotification() async {
  const settingForAndroid = AndroidInitializationSettings("launch_background");
  const initializationSettings =
      InitializationSettings(android: settingForAndroid);
  await flutterLocalNotificationPlugin.initialize(initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
}
