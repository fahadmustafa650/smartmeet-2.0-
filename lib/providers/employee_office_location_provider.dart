import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:smart_meet/models/employee_location.dart';

class EmployeeOfficeLocationProvider with ChangeNotifier {
  EmployeeLocation _employeeLocation;
  Future<EmployeeLocation> getEmployeeLocation(String employeeId) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee_location/$employeeId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //0.employeeId
      final id = jsonDecode(response.body)[0]['_id'];
      final latitude = jsonDecode(response.body)[0]['lattitude'];
      final longitude = jsonDecode(response.body)[0]['longitude'];
      print('id=$id');
      print('latitude=$latitude');
      print('longitude=$longitude');
      //final
    }
    return _employeeLocation != null ?? _employeeLocation;
  }

  void saveLocation(String employeeId, LatLng latLng) async {
    print('providerEmp=$employeeId');
    print('providerLong=${latLng.longitude}');
    print('providerLat=${latLng.latitude}');
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee_location');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'employeeId': employeeId,
          'lattitude': latLng.latitude.toString(),
          'longitude': latLng.longitude.toString(),
        }),
      );
      print('code=${response.statusCode}');
      print('body=${response.body}');
    } catch (error) {
      throw error;
    }
  }
}
