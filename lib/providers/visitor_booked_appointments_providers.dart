import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:http/http.dart' as http;
import 'package:smart_meet/models/sent_appointment_model.dart';

class VisitorAcceptedAppointmentRequestsProvider with ChangeNotifier {
  List<SentAppointment> _visitorAcceptedAppointmentRequests = [];
  List<SentAppointment> get getSentAppointmentRequests {
    return _visitorAcceptedAppointmentRequests == null
        ? []
        : [..._visitorAcceptedAppointmentRequests];
  }

  Future<void> acceptedAppointmentRequestsList(String visitorId) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/acceptedrequest/$visitorId');
    try {
      final response = await http.get(url);
      print('body=${response.body}');
      if (response.statusCode == 399) {
        _visitorAcceptedAppointmentRequests = [];
        return;
      }
      final extractedData = await json.decode(response.body) as List<dynamic>;
      print(response.body);
      // print(extractedData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _visitorAcceptedAppointmentRequests = [];
        for (var data in extractedData) {
          _visitorAcceptedAppointmentRequests.add(
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
      }
      notifyListeners();
    } catch (error) {
      print('errorOccured=$error');
      throw error;
    }
  }
}
