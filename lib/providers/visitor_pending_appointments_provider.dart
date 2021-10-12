import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:http/http.dart' as http;

class VisitorPendingAppointmentsRequestsProvider with ChangeNotifier {
  List<Appointment> _pendingAppointmentRequests = [];

  List<Appointment> get getPendingAppointmentRequests {
    return _pendingAppointmentRequests == null
        ? []
        : [..._pendingAppointmentRequests];
  }

  Future<void> pendingAppointmentRequestsList(String visitorId) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/$visitorId/pendingappointment');
    try {
      final response = await http.get(url);
      print('pendingStatusCode=${response.statusCode}');
      print(response.body);
      if (response.statusCode == 200) {
        final extractedData = await json.decode(response.body) as List<dynamic>;
        _pendingAppointmentRequests = [];
        //print('extractedData=$extractedData');
        for (var data in extractedData) {
          _pendingAppointmentRequests.add(
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
        print(_pendingAppointmentRequests);
      } else if (response.statusCode == 399) {
        _pendingAppointmentRequests = [];
      } else {
        _pendingAppointmentRequests = [];
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
    // print(_appointments);
  }

  Future<void> cancelAppointment(String id) async {
    // final id = '615a0df869234500041c6db7';
    print('appointId=$id');
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/cancelAppointment/$id');
    int index = _pendingAppointmentRequests.indexWhere((value) {
      return value.id == id;
    });
    var pendingAppointment = _pendingAppointmentRequests[index];
    if (index != -1) {
      _pendingAppointmentRequests.removeAt(index);
      print('removed');
      notifyListeners();
    }
    try {
      final response = await http.delete(url);
      print('pendingStatusCode=${response.statusCode}');
      print(response.body);
      if (response.statusCode == 200) {
        print('appointmentDeleted');
      } else {
        print('not deleted');
      }
      notifyListeners();
    } catch (error) {
      _pendingAppointmentRequests.insert(index, pendingAppointment);
      print(error);
      throw error;
    }
    // print(_appointments);
  }
}
