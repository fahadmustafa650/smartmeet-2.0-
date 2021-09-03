import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:http/http.dart' as http;
import 'package:smart_meet/models/sent_appointment_model.dart';

class SentAppointmentRequestsProvider with ChangeNotifier {
  List<SentAppointment> _sentAppointmentRequests = [];
  List<SentAppointment> get getSentAppointmentRequests {
    return _sentAppointmentRequests == null ? [] : _sentAppointmentRequests;
  }

  Future<void> sentAppointmentRequestsList(String visitorId) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/acceptedrequest/$visitorId');
    try {
      final response = await http.get(url);
      print(response.body);
      // if (jsonDecode(response.body)['message'] == null) {
      final extractedData = await json.decode(response.body) as List<dynamic>;
      final a = jsonDecode(response.body);
      print(response.body);
      print(extractedData);
      for (var data in extractedData) {
        // print(data['_id'].toString());
        // print(data['VisitorId'].toString());
        // print(data['employeeId'].toString());
        // print(data['Date'].toString());
        // print(data['CompanyName'].toString());
        // print(data['Timeslot'].toString());
        // print(data['Message'].toString());
        // print(data['AppointmentAccepted']);

        _sentAppointmentRequests.add(
          SentAppointment(
            id: data['_id'].toString(),
            visitorId: data['VisitorId'].toString(),
            employeeId: data['employeeId'].toString(),
            date: DateTime.parse(data['Date']),
            companyName: data['CompanyName'].toString(),
            timeSlot: data['Timeslot'],
            message: data['Message'].toString(),
            isAccepted: data['AppointmentAccepted'],
          ),
        );
      }
      //}
      notifyListeners();
    } catch (error) {
      print('errorOccured=$error');
      throw error;
    }
  }
}
