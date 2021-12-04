import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:http/http.dart' as http;
import 'package:smart_meet/models/runInAppointment_model.dart';

class EmployeeBookedAppointmentsProvider with ChangeNotifier {
  List<dynamic> _allBookedAppointmentRequests = [];

  List<dynamic> get getBookedAppointmentRequests {
    return _allBookedAppointmentRequests == null
        ? []
        : [..._allBookedAppointmentRequests];
  }

  Future<void> bookedAppointmentsList(String id) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/$id/hostAcceptedappointmentrequests');

    try {
      final response = await http.get(url);
      print(response.statusCode);
      print('empBody=${response.body}');
      if (response.statusCode == 200) {
        final extractedData = await json.decode(response.body) as List<dynamic>;
        final urgentBookedAppointments = extractedData[0];
        print('urgent booked appointments=$urgentBookedAppointments');
        for (var data in urgentBookedAppointments) {
          print('Data=$data');
          print('id=${data['_id']}');
          print('visitorName=${data['visitorName']}');
          print('visitorEmail=${data['visitorEmail']}');
          print('visitorPhone=${data['visitorPhone']}');
          print('employeeId=${data['employeeId']}');
          print('date=${data['date']}');
          print('time=${data['timeslot']}');
          print('isUrgent=${data['isUrgent']}');
          //print('');
          _allBookedAppointmentRequests.add(
            RunInAppointment(
              id: data['_id'],
              visitorName: data['visitorName'],
              employeeId: data['employeeId'],
              //visitorEmail: urgentBookedAppointments['visitorEmail'],
              //visitorPhone: urgentBookedAppointments['visitorPhone'],
              // companyName: urgentBookedAppointments['companyName'],
              date: DateTime.parse(data['date']),
              timeSlot: data['timeslot'],
              message: data['message'],
              isUrgent: data['isUrgent'],
            ),
          );
        }
        // final simpleBookedAppointments = extractedData[1];
        // //print(extractedData);
        // //print('extractedData=$extractedData');
        // //_allBookedAppointmentRequests = [];
        // for (var data in simpleBookedAppointments) {
        //   print('Data=$data');
        //   _allBookedAppointmentRequests.add(
        //     Appointment(
        //       id: data['_id'].toString(),
        //       visitorId: data['VisitorId'].toString(),
        //       // employeeId: data['employeeId'].toString(),
        //       date: DateTime.parse(data['Date']),
        //       timeSlot: data['Timeslot'].toString(),
        //       //message: data['Message'].toString(),
        //     ),
        //   );
        // }
      } else if (response.statusCode == 399) {
        _allBookedAppointmentRequests = [];
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
    // print(_appointments);
  }
}
