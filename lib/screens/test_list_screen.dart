import 'package:flutter/material.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:smart_meet/models/runInAppointment_model.dart';

class TestListScreen extends StatefulWidget {
  @override
  _TestListScreenState createState() => _TestListScreenState();
}

class _TestListScreenState extends State<TestListScreen> {
  List<dynamic> list = [
    Appointment(
      date: DateTime.now(),
      isUrgent: false,
      timeSlot: '1-2',
      id: 'sdf345435345',
      visitorId: '234325235',
      employeeId: '2324234243',
      companyName: 'Falak',
      message: 'hi',
    ),
    RunInAppointment(
        companyName: 'Aasmaan',
        date: DateTime.now(),
        employeeId: '34sdgdsgdgd',
        id: 'dgdgdgdf435',
        imageUrl: 'sfhdshfdskhfhsd',
        isUrgent: true,
        message: 'jsdfjsdjf',
        timeSlot: '2-3',
        visitorEmail: 'sdfdsfds',
        visitorName: 'fsfsdf',
        visitorPhone: 'sdfsf'),
    RunInAppointment(
        companyName: 'Zameen',
        date: DateTime.now(),
        employeeId: '34sdgdsgdgd',
        id: 'dgdgdgdf435',
        imageUrl: 'sfhdshfdskhfhsd',
        isUrgent: true,
        message: 'jsdfjsdjf',
        timeSlot: '2-3',
        visitorEmail: 'sdfdsfds',
        visitorName: 'fsfsdf',
        visitorPhone: 'sdfsf'),
    RunInAppointment(
        companyName: 'Jahan',
        date: DateTime.now(),
        employeeId: '34sdgdsgdgd',
        id: 'dgdgdgdf435',
        imageUrl: 'sfhdshfdskhfhsd',
        isUrgent: true,
        message: 'jsdfjsdjf',
        timeSlot: '2-3',
        visitorEmail: 'sdfdsfds',
        visitorName: 'fsfsdf',
        visitorPhone: 'sdfsf'),
    Appointment(
      date: DateTime.now(),
      isUrgent: false,
      timeSlot: '1-2',
      id: 'sdf345435345',
      visitorId: '234325235',
      employeeId: '2324234243',
      companyName: 'Plaza',
      message: 'hi',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    print('pressed=$index');
                    setState(() {
                      list.removeAt(index);
                    });
                  },
                  child: Container(
                    width: 200,
                    height: 100,
                    color: Colors.blue,
                    child: Center(
                        child: Column(
                      children: [
                        Text(
                          list[index].toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
