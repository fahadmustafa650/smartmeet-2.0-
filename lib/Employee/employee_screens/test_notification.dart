import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TestNotificationsScreen extends StatefulWidget {
  @override
  _TestNotificationsScreenState createState() =>
      _TestNotificationsScreenState();
}

class _TestNotificationsScreenState extends State<TestNotificationsScreen> {
  @override
  void initState() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    //messaging.;
    //messaging.configure();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
