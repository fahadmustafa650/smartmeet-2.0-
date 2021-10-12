import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:http/http.dart' as http;

class EmployeeBookedAppointmentsProvider with ChangeNotifier {
  List<Appointment> _bookedAppointmentRequests = [];

  List<Appointment> get getBookedAppointmentRequests {
    return _bookedAppointmentRequests == null
        ? []
        : [..._bookedAppointmentRequests];
  }

  Future<void> bookedAppointmentsList(String id) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/$id/hostAcceptedappointmentrequests');

    try {
      final response = await http.get(url);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final extractedData = await json.decode(response.body) as List<dynamic>;
        //print(extractedData);
        //print('extractedData=$extractedData');
        _bookedAppointmentRequests = [];
        for (var data in extractedData) {
          print('Data=$data');
          _bookedAppointmentRequests.add(
            Appointment(
              id: data['_id'].toString(),
              visitorId: data['VisitorId'].toString(),
              employeeId: data['employeeId'].toString(),
              date: DateTime.parse(data['Date']),
              timeSlot: data['Timeslot'].toString(),
              message: data['Message'].toString(),
            ),
          );
        }
      } else if (response.statusCode == 399) {
        _bookedAppointmentRequests = [];
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
    // print(_appointments);
  }
}
