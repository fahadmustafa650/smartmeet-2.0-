import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:smart_meet/Visitor/Visitor%20Verification%20Steps/booked_appointment_qrcode.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:smart_meet/models/sent_appointment_model.dart';
import 'package:smart_meet/providers/visitor_booked_appointments_providers.dart';
import 'package:smart_meet/providers/visitor_pending_appointments.dart';
import 'package:smart_meet/providers/visitor_provider.dart';

class VisitorPendingAppointmentsScreen extends StatefulWidget {
  static final id = '/visitor_pending_appointment_results';
  final String visitorId;
  const VisitorPendingAppointmentsScreen({
    @required this.visitorId,
  });

  @override
  _VisitorPendingAppointmentsScreenState createState() =>
      _VisitorPendingAppointmentsScreenState();
}

class _VisitorPendingAppointmentsScreenState
    extends State<VisitorPendingAppointmentsScreen> {
  List<PendingAppointment> _appointmentPendingRequests = [];
  bool _isInit = false;
  bool _isLoading = true;
  void fetchAndGetData() async {
    // String visitorId = '61292ccba64b18000460842a';
    String visitorId =
        Provider.of<VisitorProvider>(context, listen: false).getVisitor.id;
    print('passedId=$visitorId');
    try {
      await Provider.of<VisitorPendingAppointmentsRequestsProvider>(context,
              listen: false)
          .pendingAppointmentRequestsList(visitorId)
          .then((_) {
        _appointmentPendingRequests =
            Provider.of<VisitorPendingAppointmentsRequestsProvider>(context,
                    listen: false)
                .getPendingAppointmentRequests;
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
    _isInit = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      fetchAndGetData();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text('Pending Appointments'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _appointmentPendingRequests.length,
              itemBuilder: (ctx, index) {
                return EmployeeBookedInfo(
                  employeeId: _appointmentPendingRequests[index].employeeId,
                  date: DateTime.parse(
                      _appointmentPendingRequests[index].date.toString()),
                  timeSlot: _appointmentPendingRequests[index].timeSlot,
                );
              },
            ),
    );
  }
}

class EmployeeBookedInfo extends StatefulWidget {
  final String employeeId;
  final DateTime date;
  final String timeSlot;

  const EmployeeBookedInfo({
    @required this.employeeId,
    @required this.date,
    @required this.timeSlot,
  });

  @override
  _EmployeeBookedInfoState createState() => _EmployeeBookedInfoState();
}

class _EmployeeBookedInfoState extends State<EmployeeBookedInfo> {
  var responseData;
  var _isLoading = true;
  void _fetchData() async {
    print('empId=${widget.employeeId}');
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/employeeDataById/${widget.employeeId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        responseData = jsonDecode(response.body)['user'];
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 400) {}
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      _fetchData();
    });
    // print('empId=${widget.employeeId}');
  }

  @override
  Widget build(BuildContext context) {
    print(widget.timeSlot);
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            width: screenWidth * 0.9,
            margin: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02, vertical: 10.0),
            height: 150,
            child: Card(
              elevation: 3,
              child: Row(
                children: [
                  Image(
                    image: NetworkImage(responseData['avatar']),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${responseData['firstName'].toString()} ${responseData['lastName'].toString()}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMMd('en_US').format(widget.date),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.timeSlot.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: screenWidth * 0.45,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                          child: Center(
                              child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          )),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
