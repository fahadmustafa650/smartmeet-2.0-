import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_meet/Constants/constants.dart';
import 'package:smart_meet/screens/password_changed_successfully.dart';

class EmployeeNewPasswordScreen extends StatefulWidget {
  static final id = '/employee_new_password_screen';
  final String email;

  EmployeeNewPasswordScreen({
    @required this.email,
  });

  @override
  _EmployeeNewPasswordScreenState createState() =>
      _EmployeeNewPasswordScreenState();
}

class _EmployeeNewPasswordScreenState extends State<EmployeeNewPasswordScreen> {
  var _isLoading = false;
  final _newPassword = TextEditingController();
  final _newConfirmPassword = TextEditingController();

  void _updatePassword(BuildContext context) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/forgetPassword');
    setState(() {
      _isLoading = true;
    });
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': 'waqas.zfr96@gmail.com',
        'newpass': _newPassword.text
      }),
    );
    print('responseNewPassword=${response.statusCode}');
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PasswordChangedSuccess(
                  isEmployee: true,
                )),
      );
    } else {
      print('response=${response.statusCode}');
    }

    // print('upadtePassword');
    // print(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Enter New Password',
              style: TextStyle(color: Colors.white, fontSize: 25)),
          SizedBox(
            height: 20,
          ),
          newPasswordField(screenWidth),
          SizedBox(
            height: 20,
          ),
          confirmNewPasswordField(screenWidth),
          SizedBox(
            height: 20,
          ),
          updateBtn(context, screenWidth),
        ],
      ),
    );
  }

  Card newPasswordField(double screenWidth) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: TextFormField(
        controller: _newPassword,
        decoration: InputDecoration(
            labelText: 'Enter New Password',
            prefixIcon: Icon(Icons.lock),
            contentPadding: EdgeInsets.symmetric(horizontal: 5),
            border: InputBorder.none,
            labelStyle: TextStyle(color: Colors.grey, fontSize: 16)),
      ),
    );
  }

  GestureDetector updateBtn(BuildContext context, double screenWidth) {
    return GestureDetector(
      onTap: () {
        if (_newPassword.text.toString() ==
            _newConfirmPassword.text.toString()) {
          _updatePassword(context);
        }
      },
      child: Container(
        width: screenWidth * 0.7,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white, width: 1.5),
            color: Colors.blue[900]),
        child: _isLoading
            ? threeBounceSpinkit
            : Center(
                child: Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
      ),
    );
  }

  Card confirmNewPasswordField(double screenWidth) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: TextFormField(
        controller: _newConfirmPassword,
        decoration: InputDecoration(
            labelText: 'Confirm New Password',
            prefixIcon: Icon(Icons.lock),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 5),
            labelStyle: TextStyle(color: Colors.grey, fontSize: 16)),
      ),
    );
  }
}
