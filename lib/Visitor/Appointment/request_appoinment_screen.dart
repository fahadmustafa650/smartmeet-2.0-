import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_meet/providers/visitor_provider.dart';
import 'appointment_sent_screen.dart';
import 'reserve_spot_employee_screen.dart';
import 'package:http/http.dart' as http;

class RequestAppointmentScreen extends StatefulWidget {
  static final id = '/request_appoinment_screen';
  @override
  _RequestAppointmentScreenState createState() =>
      _RequestAppointmentScreenState();
}

class _RequestAppointmentScreenState extends State<RequestAppointmentScreen> {
  final name = '';
  var _nameController;
  final _companyController = TextEditingController();
  //final _messageController = TextEditingController();
  final _visitorReasonField = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedStartTime;
  String selectedEndTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      final visitorData =
          Provider.of<VisitorProvider>(context, listen: false).getVisitor;
      String visitorName = '${visitorData.firstName} ${visitorData.lastName}';
      _nameController = TextEditingController(text: visitorName);
    });
  }

  void postData() async {
    //Logged In Visitor Id will be entered
    // String visitorId = '61292ccba64b18000460842a';
    final visitorData =
        Provider.of<VisitorProvider>(context, listen: false).getVisitor;
    String visitorId = visitorData.id;
    String visitorName = '${visitorData.firstName} ${visitorData.lastName}';

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    String employeeId = routeArgs['employeeId'];
    setState(() {});
    print('empId=$employeeId');
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/appointment');
    print('employeeId=$employeeId');
    print('visitorId=$visitorId');
    print('_companyController=${_companyController.text}');
    print('_visitorReasonField=${_visitorReasonField.text}');
    print('timeSlot=$selectedStartTime-$selectedEndTime');
    print('Date=${selectedDate.toString()}');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'employeeId': employeeId,
        'VisitorId': visitorId,
        'CompanyName': _companyController.text.toString(),
        'Message': _visitorReasonField.text.toString(),
        'Timeslot': '$selectedStartTime:$selectedEndTime',
        'Date': selectedDate.toString(),
      }),
    );
    print(jsonDecode(response.body)['error']);
    if (response.statusCode == 200) {
      Navigator.pushNamed(context, AppointmentSentScreen.id);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // ignore: missing_return
  Future<DateTimePicker> _selectStartTime(BuildContext context) async {
    final _selectedTime24Hour = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 47),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (_selectedTime24Hour != null) {
      setState(() {
        selectedStartTime =
            '${_selectedTime24Hour.hour}:${_selectedTime24Hour.minute}';
        print('selectedStartTime=$selectedStartTime');
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final _selectedTime24Hour = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 47),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (_selectedTime24Hour != null) {
      setState(() {
        selectedEndTime =
            '${_selectedTime24Hour.hour}:${_selectedTime24Hour.minute}';
        print('selectedEndTime=$selectedEndTime');
      });
    }
    //selectedTime24Hour.
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      contentPadding: EdgeInsets.only(left: 10),
                      border: InputBorder.none,
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
              SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          selectedDate == null
                              ? 'Select Date'
                              : DateFormat.yMMMMd('en_US').format(selectedDate),
                          style: TextStyle(color: Colors.grey, fontSize: 18)),
                      Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
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
                              selectedStartTime == null
                                  ? 'Start Time'
                                  : selectedStartTime,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                            Icon(
                              FontAwesomeIcons.clock,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
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
                              selectedEndTime == null
                                  ? 'End Time'
                                  : selectedEndTime,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                            Icon(
                              FontAwesomeIcons.clock,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              companyNameField(),
              visitReasonField(),
              requestAppointmentBtn(context)
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector requestAppointmentBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        postData();
        //Navigator.pushNamed(context, AppointmentSentScreen.id);
      },
      child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
              color: Colors.lightBlue, borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Text(
              'Request Appointment',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          )),
    );
  }

  Container visitReasonField() {
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

  Container companyNameField() {
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
