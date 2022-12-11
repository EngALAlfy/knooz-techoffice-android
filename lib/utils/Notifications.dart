import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:techoffice/utils/Pref.dart';

/// notification
initNotifications(context) async {
  if (!(await getBool("notify") ?? true)) {
    return;
  }

  String allTopics = "all";
  FirebaseMessaging.instance.subscribeToTopic(allTopics);

  // get message when app opened from terminated
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      //EasyLoading.showInfo(value.notification.title + " test");
    }
  });

  // get message on foreground and send notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("new message : " + message.toString());
    showNotification(message.notification.title, message.notification.body);
  });

  // get message from app opened from background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //EasyLoading.showInfo(message.notification.title);
    print("app opend : " + message.notification.title);
    print(message.data);
  });

  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
}

showNotification(title, body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('0', 'fcm', 'fcm notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          showWhen: false);

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("ic_launcher");
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await flutterLocalNotificationsPlugin.show(
      0, title, body, platformChannelSpecifics);
}

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  print("background : " + message.notification.title);
}
