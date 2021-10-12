import 'package:flutter/material.dart';

import '../visitor_home_screen.dart';

class AppointmentSentScreen extends StatelessWidget {
  static final id = '/appointment_sent_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Your appointment request sent successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'We will be in touch shortly',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, VisitorHomeScreen.id);
                },
                child: Container(
                  width: 130,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                      child: Text(
                    'Go Back To Home',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
                ))
          ],
        ),
      ),
    );
  }
}
