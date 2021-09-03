import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:http/http.dart' as http;

class PendingAppointmentsRequestsProvider with ChangeNotifier {
  List<PendingAppointment> _pendingAppointmentRequests = [];
  List<PendingAppointment> get getPendingAppointmentRequests {
    return _pendingAppointmentRequests == null
        ? []
        : _pendingAppointmentRequests;
  }

  Future<void> pendingAppointmentRequestsList(String id) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/$id/pendingappointmentrequests');
    try {
      final response = await http.get(url);
      //print(response.body);
      final extractedData = await json.decode(response.body) as List<dynamic>;
      //print('extractedData=$extractedData');
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
    } catch (error) {
      print(error);
      throw error;
    }
    // print(_appointments);
  }
}
