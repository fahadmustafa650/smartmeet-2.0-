import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_meet/Visitor/Appointment/appointment_sent_screen.dart';
import 'package:smart_meet/Visitor/Visitor%20Verification%20Steps/booked_appointment_qrcode.dart';
import 'package:smart_meet/models/sent_appointment_model.dart';
import 'package:smart_meet/providers/sent_appointments_providers.dart';
import 'package:http/http.dart' as http;
import 'reserve_spot_employee_screen.dart';
import 'search_employee_screen.dart';

class BookedAppointmentsScreen extends StatefulWidget {
  static final id = '/booked_appointment_result';
  @override
  _BookedAppointmentsScreenState createState() =>
      _BookedAppointmentsScreenState();
}

class _BookedAppointmentsScreenState extends State<BookedAppointmentsScreen> {
  List<SentAppointment> _appointmentPendingRequests = [];
  bool _isInit = false;
  bool _isLoading = true;
  void fetchAndGetData() async {
    // String visitorId = '61292ccba64b18000460842a';
    String visitorId = '61292ccba64b18000460842b';
    try {
      await Provider.of<SentAppointmentRequestsProvider>(context, listen: false)
          .sentAppointmentRequestsList(visitorId)
          .then((_) {
        _appointmentPendingRequests =
            Provider.of<SentAppointmentRequestsProvider>(context, listen: false)
                .getSentAppointmentRequests;
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
        title: Text('Booked Appointments'),
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
                  startTime: TimeOfDay.fromDateTime(
                    DateTime.now(),
                  ),
                  endTime: TimeOfDay.fromDateTime(
                    DateTime.now(),
                  ),
                );
              },
            ),
    );
  }
}

class EmployeeBookedInfo extends StatefulWidget {
  final String employeeId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const EmployeeBookedInfo({
    Key key,
    @required this.employeeId,
    @required this.date,
    @required this.startTime,
    @required this.endTime,
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
      }
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
    print(widget.startTime);
    print(widget.endTime);
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
                    width: 6,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            DateFormat.yMMMMd('en_US').format(widget.date),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            '${widget.startTime.format(context)} - ${widget.endTime.format(context)}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, BookedAppointmentQRCode.id);
                        },
                        child: Container(
                          width: screenWidth * 0.45,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          child: Center(
                              child: Text(
                            'GET QR CODE',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ));
  }
}
