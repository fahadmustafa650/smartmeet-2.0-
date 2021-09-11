import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:http/http.dart' as http;

class EmployeePendingAppointmentsRequestsProvider with ChangeNotifier {
  List<PendingAppointment> _pendingAppointmentRequests = [];

  List<PendingAppointment> get getPendingAppointmentRequests {
    return _pendingAppointmentRequests == null
        ? []
        : [..._pendingAppointmentRequests];
  }

  void acceptAppointment(String id) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/acceptappointment/$id');

    try {
      final response = await http.post(url);
      print('response=${response.statusCode}');
      if (response.statusCode == 200) {
        int index = _pendingAppointmentRequests.indexWhere((value) {
          return value.id == id;
        });
        print('index=$index');
        if (index != -1) {
          _pendingAppointmentRequests.removeAt(index);
          notifyListeners();
        }
      }
    } catch (error) {
      throw error;
    }
  }

  void rejectAppointment(String id) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/rejectAppointment/$id');
    int index = _pendingAppointmentRequests.indexWhere((value) {
      return value.id == id;
    });
    var pendingAppointment = _pendingAppointmentRequests[index];
    print('index=$index');
    if (index != -1) {
      _pendingAppointmentRequests.removeAt(index);
      notifyListeners();
      try {
        final response = await http.post(url);
        print('code=${response.statusCode}');
        if (response.statusCode > 201) {
          _pendingAppointmentRequests.insert(index, pendingAppointment);
          notifyListeners();
          throw 'Could not Rejected';
        }
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
        _pendingAppointmentRequests.insert(index, pendingAppointment);
        throw error;
      }
    }
  }

  Future<void> pendingAppointmentRequestsList(String id) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/$id/pendingappointmentrequests');
    try {
      final response = await http.get(url);
      //print(response.body);
      final extractedData = await json.decode(response.body) as List<dynamic>;
      print(extractedData);
      //print('extractedData=$extractedData');
      _pendingAppointmentRequests = [];
      for (var data in extractedData) {
        _pendingAppointmentRequests.add(PendingAppointment(
          id: data['_id'].toString(),
          visitorId: data['VisitorId'].toString(),
          employeeId: data['employeeId'].toString(),
          date: DateTime.parse(data['Date']),
          timeSlot: data['Timeslot'].toString(),
          message: data['Message'].toString(),
        ));
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
    // print(_appointments);
  }
}
