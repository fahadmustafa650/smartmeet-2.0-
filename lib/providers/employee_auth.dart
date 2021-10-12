import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const apiKey = 'AIzaSyBAYvErU7DLgvhesJ0tbWaYdsTYhe88nL0';

class EmployeeAuthProvider with ChangeNotifier {
  String _token;
  DateTime _dateTime;
  String _userId;

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=$apiKey');
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    print('code=${response.statusCode}');
  }
}
