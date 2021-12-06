import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// var AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel',
//   'High Importance Channel',
//   'This Channel is used for important notifications',
//   importance: Importance.high,
//   playSound: true,
// );

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationTestScreen extends StatefulWidget {
  NotificationTestScreen({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _NotificationTestScreenState createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  int _counter = 0;

  final AndroidNotificationChannel channel = AndroidNotificationChannel(
    '123',
    'High Importance Channel',
    'This Channel is used for important notifications',
    importance: Importance.high,
    playSound: true,
  );
  @override
  void initState() {
    super.initState();
    // FirebaseMessaging.onBackgroundMessage((message) {
    //   print('message: $message');
    //   return null;
    // });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });
      }
    });
  }

  void showNotification() {
    print('id=${channel.id}');
    print('name=${channel.name}');
    print('description=${channel.description}');
    setState(() {
      _counter++;
    });

    if (channel.id == '123') {
      flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doing ?",
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            importance: Importance.high,
            color: Colors.blue,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Title'),
      ),
      body: Center(
        child: Text(
          'You have pushed the button this many times: \n$_counter',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNotification,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
