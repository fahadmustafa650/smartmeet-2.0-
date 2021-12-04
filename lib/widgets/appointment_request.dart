import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:smart_meet/Constants/constants.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:smart_meet/providers/employee_pending_appointments_provider.dart';
import 'package:smart_meet/providers/visitor_provider.dart';
import 'package:http/http.dart' as http;

final spinKitThreeBounce = SpinKitThreeBounce(
  color: Colors.blue,
  size: 10.0,
);

class VisitorAppointmentRequest extends StatefulWidget {
  final visitorAppointmentRequestData;
  final bool isUrgent;
  final int index;

  const VisitorAppointmentRequest(
      {this.visitorAppointmentRequestData, this.isUrgent, this.index});

  @override
  _VisitorAppointmentRequestState createState() =>
      _VisitorAppointmentRequestState();
}

class _VisitorAppointmentRequestState extends State<VisitorAppointmentRequest> {
  bool _isLoading = true;
  var data;
  var name;

  // void showUndoSnackbar() {
  //   final snackBar = SnackBar(
  //     content: Text('Appountment Request Rejected'),
  //     action: SnackBarAction(
  //       label: 'Undo',
  //       onPressed: () {},
  //     ),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  Future<void> showWarning() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Warning'),
        content: const Text('Are You Sure?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'No'),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // print('apId=${widget.appointmentRequestData.id}');
              Provider.of<EmployeePendingAppointmentsRequestsProvider>(context,
                      listen: false)
                  .rejectSimpleAppointment(
                      widget.visitorAppointmentRequestData.id)
                  .then((value) {
                showSnackMessage(context, 'Appointment Request Rejected');
              });
              Navigator.pop(context, 'Yes');
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> fetchUrgentAppointments() async {
    try {
      name = widget.visitorAppointmentRequestData.visitorName;
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchSimpleAppointments() async {
    try {
      print('simpleAppType=${widget.visitorAppointmentRequestData}');
      print('urgent=${widget.isUrgent}');
      print('index=${widget.index}');
      // final id = Provider.of<EmployeesProvider>(context).getEmployee.id;
      final visitorId = widget.visitorAppointmentRequestData.visitorId;
      //final visitorId = '';
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
      print('isUrgent=${widget.isUrgent}');
      print('errorIndex=${widget.index}');
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      if (widget.isUrgent) {
        fetchUrgentAppointments();
      } else {
        fetchSimpleAppointments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.visitorAppointmentRequestData.id),
      onDismissed: (direction) async {
        print(direction.index);
        if (DismissDirection.startToEnd == direction) {
          _acceptAppointment(context);
        } else {
          _rejectAppointment(context);
        }
      },
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        child: Icon(Icons.check, size: 40, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        child: Icon(Icons.clear, size: 40, color: Colors.white),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        height: 190,
        child: Card(
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.isUrgent,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 70,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Urgent',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  _isLoading
                      ? spinKitThreeBounce
                      : CircleAvatar(
                          backgroundImage: NetworkImage(widget.isUrgent
                              ? widget.visitorAppointmentRequestData.imageUrl
                              : data['avatar']),
                        ),
                  SizedBox(
                    width: 5,
                  ),
                  _isLoading
                      ? spinKitThreeBounce
                      : Text(
                          name,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _isLoading
                      ? spinKitThreeBounce
                      : CustomIconTextWidget(
                          iconData: Icons.calendar_today,
                          text: DateFormat.yMMMMd('en_US')
                              .format(widget.visitorAppointmentRequestData.date)
                              .toString(),
                        ),
                  CustomIconTextWidget(
                    iconData: Icons.timer,
                    text: widget.visitorAppointmentRequestData.timeSlot,
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
      ),
    );
  }

  void _rejectAppointment(BuildContext context) {
    try {
      Provider.of<EmployeePendingAppointmentsRequestsProvider>(context,
              listen: false)
          .rejectSimpleAppointment(widget.visitorAppointmentRequestData.id)
          .then((value) {
        if (value == 200) {
          showSnackMessage(context, 'Appointment Request Rejected');
        }
      });
    } catch (error) {
      print('index=${widget.index}');
      throw error;
    }
  }

  void _acceptAppointment(BuildContext context) async {
    try {
      await Provider.of<EmployeePendingAppointmentsRequestsProvider>(context,
              listen: false)
          .acceptSimpleAppointment(widget.visitorAppointmentRequestData.id)
          .then((value) {
        if (value == 200) {
          showSnackMessage(context, 'Appointment Request Accepted');
        }
      });
    } catch (error) {
      throw error;
    }
  }

  void showSnackMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 500),
    ));
  }

  Widget acceptButton() {
    return GestureDetector(
      onTap: () {
        _acceptAppointment(context);
      },
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
      onTap: () {
        showWarning();
      },
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
