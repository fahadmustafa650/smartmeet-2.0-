import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_meet/models/employee_model.dart';
import 'package:http/http.dart' as http;

class EmployeesProvider with ChangeNotifier {
  Employee _employee;

  Employee get getEmployee {
    return _employee == null ? Employee() : _employee;
  }

  Future<void> getEmployeeDataById(String id) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/$id/viewProfile');
    final response = await http.get(url);
    final employeeData = jsonDecode(response.body);
    _employee = Employee(
      id: employeeData['user']['id'].toString(),
      firstName: employeeData['user']['firstName'].toString(),
      lastName: employeeData['user']['lastName'].toString(),
      username: employeeData['user']['username'].toString(),
      email: employeeData['user']['email'].toString(),
      dateOfBirth: DateTime.tryParse(employeeData['user']['dateOfBirth']),
      imageUrl: employeeData['user']['avatar'].toString(),
    );
    notifyListeners();
  }

  void destroyEmployee() {
    _employee = Employee(
      id: null,
      firstName: null,
      lastName: null,
      username: null,
      email: null,
      dateOfBirth: null,
      imageUrl: null,
    );
  }

  Future<void> getEmployeeDataByEmail(String email) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/$email/viewProfile');
    final response = await http.get(url);
    final employeeData = jsonDecode(response.body);
    _employee = Employee(
      id: employeeData['user']['_id'].toString(),
      firstName: employeeData['user']['firstName'].toString(),
      lastName: employeeData['user']['lastName'].toString(),
      username: employeeData['user']['username'].toString(),
      email: email,
      dateOfBirth: DateTime.tryParse(employeeData['user']['dateOfBirth']),
      imageUrl: employeeData['user']['avatar'].toString(),
    );
    notifyListeners();
  }

  Future<int> updateEmployeeData(Employee employeeData) async {
    final prevEmployeeData = getEmployee;
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/updateProfile');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'id': employeeData.id,
        'firstName': employeeData.firstName != null
            ? employeeData.firstName
            : prevEmployeeData.firstName,
        'lastName': employeeData.lastName != null
            ? employeeData.lastName
            : prevEmployeeData.lastName,
        'avatar': employeeData.imageUrl != null
            ? employeeData.imageUrl
            : prevEmployeeData.imageUrl,
      }),
    );
    if (response.statusCode == 200) {
      print('Data Updated');
      _employee = Employee(
        id: prevEmployeeData.id,
        firstName: employeeData.firstName != null
            ? employeeData.firstName
            : prevEmployeeData.firstName,
        lastName: employeeData.lastName != null
            ? employeeData.lastName
            : prevEmployeeData.lastName,
        username: prevEmployeeData.username,
        email: prevEmployeeData.email,
        dateOfBirth: prevEmployeeData.dateOfBirth,
        imageUrl: employeeData.imageUrl != null
            ? employeeData.imageUrl
            : prevEmployeeData.imageUrl,
      );

      notifyListeners();
      return response.statusCode;
    } else {
      print('error occured in updating');

      notifyListeners();
      return response.statusCode;
    }
  }
}
