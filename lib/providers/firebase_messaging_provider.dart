import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// final firebaseMessagingProvider = Provider<FirebaseMessagingProvider>((ref) {
//   return FirebaseMessagingProvider(ref.read);
// });

class FirebaseMessagingProvider {
  FirebaseMessagingProvider();
  final messaging = FirebaseMessaging.instance;

  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );
  static init() async {
    // flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

  void initFCM() async {
    final settings =
        await messaging.requestPermission(badge: true, alert: true);
    log(
      'User granted permission: ${settings.authorizationStatus}',
      name: 'FirebaseMessagingProvider',
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log('onMessageOpenedApp', name: 'FirebaseMessagingProvider');
      log('Message data: ${message.data}', name: 'FirebaseMessagingProvider');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!',
          name: 'FirebaseMessagingProvider');
      log('Message data: ${message.data}', name: 'FirebaseMessagingProvider');

      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification}');
      }
      final notification = message.notification;
      final android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              priority: Priority.max,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    log('FCM Device Token: ${await getToken()}',
        name: 'FirebaseMessagingProvider');
  }

  Future<String> getToken() {
    return messaging.getToken();
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a background message ${message.messageId}',
      name: 'FirebaseMessagingProvider');
}

// Once created, we can now update FCM to use our own channel rather than the default FCM one.
// To do this, open the android/app/src/main/AndroidManifest.xml file for your FlutterProject project.
// Add the following meta-data schema within the application component:

// <meta-data
//   android:name="com.google.firebase.messaging.default_notification_channel_id"
//   android:value="high_importance_channel" />