import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_meet/Constants/constants.dart';
import 'package:smart_meet/Visitor/Appointment/appointment_sent_screen.dart';
import 'package:smart_meet/api/firebase_api.dart';
import 'package:smart_meet/providers/visitor_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'reserve_spot_employee_screen.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class RunInAppointmentScreen extends StatefulWidget {
  static final id = '/run_in_appoinment_screen';
  final String employeeId;
  RunInAppointmentScreen({this.employeeId});
  @override
  _RunInAppointmentScreenState createState() => _RunInAppointmentScreenState();
}

class _RunInAppointmentScreenState extends State<RunInAppointmentScreen> {
  // final name = '';

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //final _messageController = TextEditingController();
  final _visitorReasonField = TextEditingController();
    if (_selectedTime24Hour != null) {
            _selectedTime24Hour.minute >= now.minute) {
            _selectedStartTime24Hour = _selectedTime24Hour;
          });

          return;
        } else if (_selectedTime24Hour.hour < now.hour) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("Selected Time must not be previous than Current Time"),
              duration: Duration(milliseconds: 2000),
            ),
          );
          return;
          //print('Time is not after');
        }
        // now.isAfter();
        // print('nowHour=${now.hour}');
        // print('newMint=${now.minute}');
        // print('selectedStartTime=$selectedStartTime');
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    print('selectedStartTime24Hour=${_selectedStartTime}');
    if (_selectedStartTime == null) {
      //_selectedEndTime = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Select Starting Time First"),
          duration: Duration(milliseconds: 2000),
        ),
      );
      return;
    }
    final _selectedTime24Hour = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    // print('24hourtime=$_selectedTime24Hour');
    // print('Select Starting Time =$_selectedStartTime');
    if (_selectedTime24Hour != null) {
      if (_selectedTime24Hour.hour < _selectedStartTime24Hour.hour ||
          (_selectedTime24Hour == _selectedStartTime24Hour)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("End Time must not be before/equal to  Starting Time"),
            duration: Duration(milliseconds: 2000),
          ),
        );
        return;
      }
      String _endTime =
          '${_selectedTime24Hour.hour}:${_selectedTime24Hour.minute}';
      setState(() {
        _selectedEndTime = _endTime;
      });
      //print('time24hour=$_endTime');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Request Appoinment',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _imgFromCamera();
                    //Navigator.pop(context);
                  },
                  child: Container(
                    width: 128,
                    height: 128,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.camera_alt,
                              size: 25,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 128,
                          backgroundColor: Colors.transparent,
                          backgroundImage: _image != null
                              ? FileImage(_image)
                              : AssetImage('assets/images/blank_pic.jpg'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [_firstNameField(), _lastNameField()],
              ),
              SizedBox(
                height: 5,
              ),
              _emailTextField(),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _startTimeBtn(context),
                    _endTimeBtn(context),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              _companyNameField(),
              _visitReasonField(),
              _requestAppointmentBtn(context)
            ],
          ),
        ),
      ),
    );
  }

  Expanded _lastNameField() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: TextFormField(
          controller: _lastNameController,
          decoration: InputDecoration(
              labelText: 'Last Name',
              contentPadding: EdgeInsets.only(left: 10),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.lightBlue,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              labelStyle: TextStyle(color: Colors.grey, fontSize: 18)),
        ),
      ),
    );
  }

  Expanded _firstNameField() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: TextFormField(
          controller: _firstNameController,
          decoration: InputDecoration(
              labelText: 'First Name',
              contentPadding: EdgeInsets.only(left: 10),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.lightBlue,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              labelStyle: TextStyle(color: Colors.grey, fontSize: 18)),
        ),
      ),
    );
  }

  GestureDetector _startTimeBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _selectStartTime(context);
      },
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: MediaQuery.of(context).size.width * 0.4,
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              _selectedStartTime == null ? 'Start Time' : _selectedStartTime,
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            Icon(
              FontAwesomeIcons.clock,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _endTimeBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _selectEndTime(context);
      },
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: MediaQuery.of(context).size.width * 0.4,
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              _selectedEndTime == null ? 'End Time' : _selectedEndTime,
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            Icon(
              FontAwesomeIcons.clock,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _requestAppointmentBtn(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // postData(context);
        String _token = await FirebaseMessaging.instance.getToken();
        print(_token);

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          RemoteNotification notification = message.notification;
          AndroidNotification android = message.notification?.android;
          if (notification != null && android != null && !kIsWeb) {
            flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  icon: 'app_icon',
                ),
              ),
            );
          }
        });
        //Navigator.pushNamed(context, AppointmentSentScreen.id);
      },
      child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
              color: Colors.lightBlue, borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: _isLoading
                ? threeBounceSpinkit
                : Text(
                    'Request Appointment',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
          )),
    );
  }

  Container _visitReasonField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: TextFormField(
        minLines: 5,
        maxLines: 10,
        controller: _visitorReasonField,
        decoration: InputDecoration(
            hintText:
                'In order to better serve you please let us know your reason to visit',
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            border: InputBorder.none,
            labelStyle: TextStyle(color: Colors.grey, fontSize: 18)),
      ),
    );
  }

  Container _companyNameField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: _companyController,
        decoration: InputDecoration(
            labelText: 'Company name (Optional)',
            contentPadding: EdgeInsets.only(left: 10),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            labelStyle: TextStyle(color: Colors.grey, fontSize: 18)),
      ),
    );
  }

  Container _emailTextField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
            labelText: 'Email',
            contentPadding: EdgeInsets.only(left: 10),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            labelStyle: TextStyle(color: Colors.grey, fontSize: 18)),
      ),
    );
  }
}
