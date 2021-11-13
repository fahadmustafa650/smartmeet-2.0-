import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:http/http.dart' as http;

class EmployeePendingAppointmentsRequestsProvider with ChangeNotifier {
  List<Appointment> _pendingAppointmentRequestsList = [];

  List<Appointment> get getPendingAppointmentRequests {
    return _pendingAppointmentRequestsList == null
        ? []
        : [..._pendingAppointmentRequestsList];
  }

  Future<int> acceptAppointment(String id) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/acceptappointment/$id');

    try {
      final response = await http.post(url);
      print('response=${response.statusCode}');
      if (response.statusCode == 200) {
        int index = _pendingAppointmentRequestsList.indexWhere((value) {
          return value.id == id;
        });
        print('index=$index');
        if (index != -1) {
          _pendingAppointmentRequestsList.removeAt(index);
          notifyListeners();
        }
      }
      return response.statusCode;
    } catch (error) {
      throw error;
    }
  }

  Future<int> rejectAppointment(String id) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/rejectAppointment/$id');
    int index = _pendingAppointmentRequestsList.indexWhere((value) {
      return value.id == id;
    });
    var pendingAppointment = _pendingAppointmentRequestsList[index];
    print('index=$index');
    if (index != -1) {
      _pendingAppointmentRequestsList.removeAt(index);
      notifyListeners();
      try {
        final response = await http.post(url);
        print('code=${response.statusCode}');
        if (response.statusCode > 201) {
          _pendingAppointmentRequestsList.insert(index, pendingAppointment);
          notifyListeners();
        }
        return response.statusCode;
        // if (response.statusCode == 200) {
        //   // int index = _pendingAppointmentRequests.indexWhere((value) {
        //   //   return value.id == id;
        //   // });
        //   // print('index=$index');
        //   // if (index != -1) {
        //   //   _pendingAppointmentRequests.removeAt(index);
        //   // }
        // }
      } catch (error) {
        _pendingAppointmentRequestsList.insert(index, pendingAppointment);
        notifyListeners();
        throw error;
      }
    }
    return 0;
  }

  Future<void> pendingAppointmentRequestsList(String id) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/$id/pendingappointmentrequests');
    try {
      final response = await http.get(url);
      print('body=${response.body}');
      print('code=${response.statusCode}');
      if (response.statusCode == 200) {
        final extractedData = await json.decode(response.body) as List<dynamic>;
        //print(extractedData);
        //print('extractedData=$extractedData');
        _pendingAppointmentRequestsList = [];
        for (var data in extractedData) {
          _pendingAppointmentRequestsList.add(
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
        _pendingAppointmentRequestsList = [];
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
    // print(_appointments);
  }
}
