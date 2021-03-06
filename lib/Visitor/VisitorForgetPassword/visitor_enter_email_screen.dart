import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_meet/Constants/constants.dart';
import 'package:smart_meet/Visitor/VisitorForgetPassword/visitor_new_password_screen.dart';
import 'package:smart_meet/screens/otp_screen.dart';
import 'package:http/http.dart' as http;

class VisitorEnterEmailScreen extends StatefulWidget {
  static final id = '/visitor_enter_email_screen';

  @override
  _VisitorEnterEmailScreenState createState() =>
      _VisitorEnterEmailScreenState();
}

class _VisitorEnterEmailScreenState extends State<VisitorEnterEmailScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  void _goToNewPasswordScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return VisitorNewPasswordScreen(
        email: _emailController.text.toString(),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 60, color: Colors.white),
          SizedBox(
            height: 15,
          ),
          _topHeading(screenWidth),
          SizedBox(
            height: 20,
          ),
          _emailField(screenWidth),
          SizedBox(
            height: 20,
          ),
          _sendBtn(context, screenWidth)
        ],
      ),
    );
  }

  Container _topHeading(double screenWidth) {
    return Container(
      width: screenWidth * 0.4,
      child: Text(
        'Forgot your Password?',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          //fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  Card _emailField(double screenWidth) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Type Your Email',
          contentPadding: EdgeInsets.symmetric(horizontal: 5),
          labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }

  GestureDetector _sendBtn(BuildContext context, double screenWidth) {
    return GestureDetector(
      onTap: () {
        _isEmailExist();
      },
      child: Container(
        width: screenWidth * 0.35,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white, width: 1.5),
            color: Colors.blue[700]),
        child: _isLoading
            ? threeBounceSpinkit
            : Center(
                child: Text(
                  'Send',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _isEmailExist() async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/verifyemail/${_emailController.text.toString()}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return OtpScreen(
                email: _emailController.text.toString(),
                addAllData: _goToNewPasswordScreen,
              );
            },
          ),
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      throw error;
    }
  }
}
