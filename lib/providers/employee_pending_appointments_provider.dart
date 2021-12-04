import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:http/http.dart' as http;
import 'package:smart_meet/models/runInAppointment_model.dart';

class EmployeePendingAppointmentsRequestsProvider with ChangeNotifier {
  List<Appointment> _pendingAppointmentRequestsList = [];
  List<RunInAppointment> _runInAppointmentsRequestList = [];
  List<dynamic> _allAppointmentsList = [];
  List<Appointment> get getPendingAppointmentRequests {
    return _pendingAppointmentRequestsList == null
        ? []
        : [..._pendingAppointmentRequestsList];
  }

  List<RunInAppointment> get getPendingRunInAppointmentRequests {
    return _runInAppointmentsRequestList == null
        ? []
        : [..._runInAppointmentsRequestList];
  }

  List<dynamic> get getAllAppointments {
    return _allAppointmentsList == null ? [] : [..._allAppointmentsList];
  }

  void allPendingAppointmentsList() {
    print('All Pending Appointments');
    if (_pendingAppointmentRequestsList != null &&
        _runInAppointmentsRequestList != null) {
      _runInAppointmentsRequestList.forEach((element) {
        _allAppointmentsList.add(element);
      });
      _pendingAppointmentRequestsList.forEach((element) {
        _allAppointmentsList.add(element);
      });
      print('all App Length=${_allAppointmentsList.length}');
    }
  }

  Future<int> acceptAppointment(String id) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/acceptappointment/$id');
    int index = _allAppointmentsList.indexWhere((value) {
      return value.id == id;
    });
    var pendingAppointment = _allAppointmentsList[index];
    try {
      if (index != -1) {
        _allAppointmentsList.removeAt(index);
        notifyListeners();
      }
      final response = await http.post(url);
      print('response=${response.statusCode}');
      if (response.statusCode >= 400) {
        _allAppointmentsList.insert(index, pendingAppointment);
        notifyListeners();
        //print('index=$index');

      }
      return response.statusCode;
    } catch (error) {
      _allAppointmentsList.insert(index, pendingAppointment);
      throw error;
    }
  }

  Future<int> rejectAppointment(String id) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/rejectAppointment/$id');
    int index = _pendingAppointmentRequestsList.indexWhere((value) {
      return value.id == id;
    });
    print('index=$index');
    var pendingAppointment = _allAppointmentsList[index];

    if (index != -1) {
      _allAppointmentsList.removeAt(index);
      notifyListeners();
      try {
        final response = await http.post(url);
        print('rejectCode=${response.statusCode}');
        if (response.statusCode > 201) {
          _allAppointmentsList.insert(index, pendingAppointment);
          notifyListeners();
        }
        return response.statusCode;
      } catch (error) {
        print('providererrorindex=$index');
        _allAppointmentsList.insert(index, pendingAppointment);
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
      // print('body=${response.body}');
      // print('code=${response.statusCode}');
      if (response.statusCode == 200) {
        final extractedData = await json.decode(response.body) as List<dynamic>;
        final pendingAppointmentData = extractedData[1] as List<dynamic>;

        //print(extractedData);
        print('pendingData=$pendingAppointmentData');
        print('pendingDataLength=${pendingAppointmentData.length}');
        _pendingAppointmentRequestsList = [];
        for (var data in pendingAppointmentData) {
          _pendingAppointmentRequestsList.add(
            Appointment(
              id: data['_id'].toString(),
              visitorId: data['VisitorId'].toString(),
              employeeId: data['employeeId'].toString(),
              date: DateTime.parse(data['Date']),
              timeSlot: data['Timeslot'].toString(),
              message: data['Message'].toString(),
              isUrgent: data['isUrgent'],
            ),
          );
        }
        final pendingRunInAppoitnments = extractedData[0] as List<dynamic>;
        print('pendingRunInAppoitnments=$pendingRunInAppoitnments');
        print('lengthh=${pendingRunInAppoitnments.length}');
        _runInAppointmentsRequestList = [];
        for (var data in pendingRunInAppoitnments) {
          _runInAppointmentsRequestList.add(
            RunInAppointment(
              id: data['_id'].toString(),
              //employeeId: data['employeeId'],
              date: DateTime.parse(data['date']),
              visitorName: data['visitorName'].toString(),
              visitorEmail: data['visitorEmail'].toString(),
              visitorPhone: data['visitorPhone'],
              imageUrl: data['avatar'].toString(),
              companyName: data['companyName'].toString(),
              timeSlot: data['timeslot'].toString(),
              message: data['message'].toString(),
              isUrgent: data['isUrgent'] as bool,
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

  Future<void> pendingRunInAppointmentRequestsList(String id) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/$id/pendingappointmentrequests');
    try {
      final response = await http.get(url);
      // print('body=${response.body}');
      // print('code=${response.statusCode}');
      if (response.statusCode == 200) {
        final extractedData = await json.decode(response.body) as List<dynamic>;
        //final pendingRunInAppoitnments = extractedData[0] as List<dynamic>;
        //print(extractedData);
        print('RunInData=$extractedData');
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
