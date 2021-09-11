import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:http/http.dart' as http;
import 'package:smart_meet/models/sent_appointment_model.dart';

class AcceptedAppointmentRequestsProvider with ChangeNotifier {
  List<SentAppointment> _acceptedAppointmentRequests = [];
  List<SentAppointment> get getSentAppointmentRequests {
    return _acceptedAppointmentRequests == null
        ? []
        : [..._acceptedAppointmentRequests];
  }

  Future<void> acceptedAppointmentRequestsList(String visitorId) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/acceptedrequest/$visitorId');
    try {
      final response = await http.get(url);
      final extractedData = await json.decode(response.body) as List<dynamic>;
      print(response.body);
      // print(extractedData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _acceptedAppointmentRequests = [];
        for (var data in extractedData) {
          _acceptedAppointmentRequests.add(
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
