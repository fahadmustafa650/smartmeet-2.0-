import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_meet/models/employee_model.dart';
import 'package:smart_meet/models/visitor_model.dart';
import 'package:http/http.dart' as http;

class EmployeesProvider with ChangeNotifier {
  Employee _employee;

  Employee get getEmployee {
    return _employee == null ? Employee() : _employee;
  }

  Future<void> getEmployeeData(String email) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/$email/viewProfile');
    final response = await http.get(url);
    final employeeData = jsonDecode(response.body);
    _employee = Employee(
      id: employeeData['user']['id'].toString(),
      firstName: employeeData['user']['firstName'].toString(),
      lastName: employeeData['user']['lastName'].toString(),
      username: employeeData['user']['username'].toString(),
      email: email,
      dateOfBirth: DateTime.tryParse(employeeData['user']['dateOfBirth']),
      imageUrl: employeeData['user']['avatar'].toString(),
    );
    notifyListeners();
  }
}
