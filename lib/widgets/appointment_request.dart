import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:smart_meet/providers/appointments_provider.dart';
import 'package:smart_meet/providers/visitor_provider.dart';
import 'package:http/http.dart' as http;

class AppointmentRequest extends StatefulWidget {
  final PendingAppointment appointmentRequestData;

  const AppointmentRequest({this.appointmentRequestData});

  @override
  _AppointmentRequestState createState() => _AppointmentRequestState();
}

class _AppointmentRequestState extends State<AppointmentRequest> {
  bool _isLoading = true;
  var data;
  var name;
  Future<void> fetchData() async {
    try {
      // final id = Provider.of<EmployeesProvider>(context).getEmployee.id;
      final visitorId = widget.appointmentRequestData.visitorId;
      print('visitorId=$visitorId');
      if (visitorId == null) return;
      final url = Uri.parse(
          'https://pure-woodland-42301.herokuapp.com/api/visitor/usersProfile/$visitorId');
      final response = await http.get(url);
      data = jsonDecode(response.body)['user'];
      setState(() {
        _isLoading = false;
        name = '${data['firstName']} ${data['lastName']}';
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            height: 150,
            child: Card(
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(data['avatar']),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomIconTextWidget(
                        iconData: Icons.calendar_today,
                        text: widget.appointmentRequestData.date.toString(),
                      ),
                      CustomIconTextWidget(
                        iconData: Icons.timer,
                        text: widget.appointmentRequestData.timeSlot,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [acceptButton(), rejectButton()],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
  }

  Widget acceptButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 35,
        width: 160,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            'Accept',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget rejectButton() {
    return GestureDetector(
      child: Container(
        height: 36,
        width: 160,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: const Text(
            'Reject',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showToast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(0.4),
        textColor: Colors.white,
        fontSize: 13.0);
  }
}

class CustomIconTextWidget extends StatelessWidget {
  final IconData iconData;
  final String text;
  const CustomIconTextWidget({
    Key key,
    @required this.iconData,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.grey,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
