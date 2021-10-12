import 'package:flutter/material.dart';
import 'package:smart_meet/Employee/employee_screens/emp_sign_in_screen.dart';
import 'package:smart_meet/Employee/employee_screens/employee_home_screen.dart';
import 'package:smart_meet/Visitor/Visitor%20Authentication/visitor_sign_in_screen.dart';
import 'package:smart_meet/Visitor/visitor_home_screen.dart';

class PasswordChangedSuccess extends StatelessWidget {
  static final id = '/password_changed_successfully';
  final bool isEmployee;
  PasswordChangedSuccess({@required this.isEmployee});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.blue,
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 200,
                ),
                Text(
                  'Password Changed Successfully',
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {
                      if (isEmployee) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return EmployeeSignInScreen();
                        }));
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return VisitorSignInScreen();
                        }));
                      }
                    },
                    child: Text(
                      'Go to Sign In',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
