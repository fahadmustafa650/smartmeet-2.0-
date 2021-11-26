import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_meet/Visitor/Appointment/appointment_sent_screen.dart';
import 'package:smart_meet/providers/visitor_provider.dart';
// import 'reserve_spot_employee_screen.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;

class RunInAppointmentScreen extends StatefulWidget {
  static final id = '/run_in_appoinment_screen';
  @override
  _RunInAppointmentScreenState createState() => _RunInAppointmentScreenState();
}

class _RunInAppointmentScreenState extends State<RunInAppointmentScreen> {
  // final name = '';

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyController = TextEditingController();
  //final _messageController = TextEditingController();
  final _visitorReasonField = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedStartTime;
  String _selectedEndTime;
  String profilePicError = '';
  //file
  io.File _image;
  void postData() async {
    //Logged In Visitor Id will be entered
    // String visitorId = '61292ccba64b18000460842a';
    final visitorData =
        Provider.of<VisitorProvider>(context, listen: false).getVisitor;
    String _visitorId = visitorData.id;

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    String _employeeId = routeArgs['employeeId'];
    setState(() {});
    print('empId=$_employeeId');
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/appointment');
    // print('employeeId=$employeeId');
    // print('visitorId=$visitorId');
    // print('_companyController=${_companyController.text}');
    // print('_visitorReasonField=${_visitorReasonField.text}');
    // print('timeSlot=$selectedStartTime-$selectedEndTime');
    // print('Date=${selectedDate.toString()}');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'employeeId': _employeeId,
        'VisitorId': _visitorId,
        'CompanyName': _companyController.text.toString(),
        'Message': _visitorReasonField.text.toString(),
        'Timeslot': '$_selectedStartTime-$_selectedEndTime',
        'Date': _selectedDate.toString(),
      }),
    );
    //print(jsonDecode(response.body)['error']);
    if (response.statusCode == 200) {
      print('appointmentSent=${response.statusCode}');
      Navigator.pushNamed(context, AppointmentSentScreen.id);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = io.File(image.path);
      profilePicError = '';
    });
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
        DateTime now = DateTime.now();
        if (_selectedTime24Hour.hour >= now.hour &&
            _selectedTime24Hour.minute >= now.minute) {
          setState(() {
            _selectedStartTime =
                '${_selectedTime24Hour.hour}:${_selectedTime24Hour.minute}';
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
        // final f =  DateFormat.yMMMMd('en_US').format(DateTime.parse(selectedStartTime));
        if (_selectedStartTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Select Starting Time First"),
              duration: Duration(milliseconds: 500),
            ),
          );
          // print('Select Starting Time First');
        } else if (!(DateTime.parse(_selectedStartTime)
            .isBefore(DateTime.parse(_selectedEndTime)))) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("End Time must not before Start Time"),
              duration: Duration(milliseconds: 2000),
            ),
          );
        } else {
          setState(() {
            _selectedEndTime =
                '${_selectedTime24Hour.hour}:${_selectedTime24Hour.minute}';
            print('endtime=$_selectedEndTime');
          });
        }
      });
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
                    Navigator.pop(context);
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
                children: [
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            labelStyle:
                                TextStyle(color: Colors.grey, fontSize: 18)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            labelStyle:
                                TextStyle(color: Colors.grey, fontSize: 18)),
                      ),
                    ),
                  )
                ],
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

  GestureDetector _selectDateBtn(BuildContext context) {
    return GestureDetector(
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
                _selectedDate == null
                    ? 'Select Date'
                    : DateFormat.yMMMMd('en_US').format(_selectedDate),
                style: TextStyle(color: Colors.grey, fontSize: 18)),
            Icon(
              Icons.calendar_today,
              color: Colors.grey,
            )
          ],
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
        controller: _companyController,
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
