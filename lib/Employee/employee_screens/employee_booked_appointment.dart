import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_meet/Visitor/Visitor%20Verification%20Steps/booked_appointment_qrcode.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:smart_meet/models/sent_appointment_model.dart';
import 'package:smart_meet/providers/employee_booked_appointment_provider.dart';
import 'package:smart_meet/providers/employee_provider.dart';
import 'package:smart_meet/providers/visitor_booked_appointments_providers.dart';
import 'package:http/http.dart' as http;
import 'package:string_extensions/string_extensions.dart';

// extension CapExtension on String {
//   String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
//   String get allInCaps => this.toUpperCase();
//   String get capitalizeFirstofEach =>
//       this.split(" ").map((str) => str.capitalize).join(" ");
// }

class EmployeeBookedAppointmentsScreen extends StatefulWidget {
  static final id = '/employee_booked_appointment_result';
  @override
  _EmployeeBookedAppointmentsScreenState createState() =>
      _EmployeeBookedAppointmentsScreenState();
}

class _EmployeeBookedAppointmentsScreenState
    extends State<EmployeeBookedAppointmentsScreen> {
  bool _isInit = false;
  bool _isLoading = true;
  List<Appointment> _appointmentBookedAppointments;
  void fetchAndGetData() async {
    final employeeId =
        Provider.of<EmployeesProvider>(context, listen: false).getEmployee.id;
    //final employeeId = '6160912d9ddfb800041e6fd5';

    // String name =
    //     '${Provider.of<EmployeesProvider>(context, listen: false).getEmployee.firstName} ${Provider.of<EmployeesProvider>(context, listen: false).getEmployee.lastName} ';
    // print('logIn=$employeeId');
    // print('name=$name');
    if (employeeId == null) {
      return;
    }
    try {
      print('abc');
      await Provider.of<EmployeeBookedAppointmentsProvider>(context,
              listen: false)
          .bookedAppointmentsList(employeeId)
          .then((_) {
        _appointmentBookedAppointments =
            Provider.of<EmployeeBookedAppointmentsProvider>(context,
                    listen: false)
                .getBookedAppointmentRequests;
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      print('error=$error');
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
        title: Text('Accepted Appointments'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _appointmentBookedAppointments.length == 0
              ? Center(child: Text('No Booked Appointments'))
              : ListView.builder(
                  itemCount: _appointmentBookedAppointments.length,
                  itemBuilder: (ctx, index) {
                    return EmployeeBookedInfo(
                      visitorId:
                          _appointmentBookedAppointments[index].visitorId,
                      date: DateTime.parse(_appointmentBookedAppointments[index]
                          .date
                          .toString()),
                      timeSlot: _appointmentBookedAppointments[index].timeSlot,
                    );
                  },
                ),
    );
  }
}

class EmployeeBookedInfo extends StatefulWidget {
  final String visitorId;
  final DateTime date;
  final String timeSlot;

  const EmployeeBookedInfo({
    @required this.visitorId,
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
    print('visiId=${widget.visitorId}');
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/usersProfile/${widget.visitorId}');
    try {
      final response = await http.get(url);
      print('visitorBody=${response.body}');
      if (response.statusCode == 200) {
        responseData = jsonDecode(response.body)['user'];
        // print('fName=${responseData['firstName']}');
        // print('lName=${responseData['lastName']}');
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
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.black,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            DateFormat.yMMMMd('en_US').format(widget.date),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.timer,
                            color: Colors.black,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.timeSlot,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.pushNamed(
                      //         context, BookedAppointmentQRCode.id);
                      //   },
                      //   child: Container(
                      //     width: screenWidth * 0.45,
                      //     height: 40,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       color: Colors.blue,
                      //     ),
                      //     child: Center(
                      //         child: Text(
                      //       'GET QR CODE',
                      //       style: TextStyle(color: Colors.white, fontSize: 16),
                      //     )),
                      //   ),
                      // )
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
