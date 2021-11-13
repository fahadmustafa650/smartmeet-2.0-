import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:smart_meet/providers/employee_pending_appointments_provider.dart';
import 'package:smart_meet/providers/visitor_provider.dart';
import 'package:http/http.dart' as http;

class VisitorAppointmentRequest extends StatefulWidget {
  final Appointment visitorAppointmentRequestData;
  const VisitorAppointmentRequest({this.visitorAppointmentRequestData});

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
            onPressed: () async {
              // print('apId=${widget.appointmentRequestData.id}');
              await Provider.of<EmployeePendingAppointmentsRequestsProvider>(
                      context,
                      listen: false)
                  .rejectAppointment(widget.visitorAppointmentRequestData.id)
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

  Future<void> fetchData() async {
    try {
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
        : Dismissible(
            key: ValueKey(widget.visitorAppointmentRequestData.id),
            onDismissed: (direction) async {
              print(direction.index);
              if (DismissDirection.startToEnd == direction) {
                acceptAppointment(context);
              } else {
                rejectAppointment(context);
              }
            },
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              child: Icon(Icons.add, size: 40, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Theme.of(context).errorColor,
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete, size: 40, color: Colors.white),
            ),
            child: Container(
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

  void rejectAppointment(BuildContext context) {
    try {
      Provider.of<EmployeePendingAppointmentsRequestsProvider>(context,
              listen: false)
          .rejectAppointment(widget.visitorAppointmentRequestData.id);
    } catch (error) {
      throw error;
    }
  }

  void acceptAppointment(BuildContext context) async {
    try {
      await Provider.of<EmployeePendingAppointmentsRequestsProvider>(context,
              listen: false)
          .acceptAppointment(widget.visitorAppointmentRequestData.id)
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
        acceptAppointment(context);
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
