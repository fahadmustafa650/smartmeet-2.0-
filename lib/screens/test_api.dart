import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:smart_meet/providers/employee_pending_appointments_provider.dart';

class TestApi extends StatefulWidget {
  const TestApi({Key key}) : super(key: key);

  @override
  _TestApiState createState() => _TestApiState();
}

class _TestApiState extends State<TestApi> {
  String imageUrl;
  var isLoading = true;
  void getData() async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/acceptedrequest/qrcode/61292ccba64b18000460842a');
    final response = await http.get(url);
    // final extractedData = json.decode(response.body)['data'];
    imageUrl = response.body;
    final a = imageUrl.indexOf(',');
    imageUrl = imageUrl.substring(a + 1, imageUrl.length);

    setState(() {
      isLoading = false;
    });
    // print(extractedData);
  }

  getAppointment() async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/6160912d9ddfb800041e6fd5/pendingappointmentrequests');
    final response = await http.get(url);
    final extractedData = await json.decode(response.body) as List<dynamic>;
    print('extractedData===>$extractedData');
    final pendingAppointmentData = extractedData[0] as List<dynamic>;
    print('pendingAppointments$pendingAppointmentData');
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: getAppointment,
            child: Text('Get Data'),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Image(
                  image: MemoryImage(base64Decode(imageUrl)),
                )
        ],
      ),
    ));
  }
}
