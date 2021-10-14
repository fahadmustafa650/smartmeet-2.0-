import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_meet/Constants/constants.dart';
import 'package:smart_meet/Visitor/VisitorForgetPassword/visitor_enter_email_screen.dart';
import 'package:smart_meet/Visitor/visitor_home_screen.dart';
import 'package:smart_meet/widgets/login_with_fb.dart';
import 'package:smart_meet/widgets/login_with_google.dart';

import 'visitor_sign_up_screen.dart';

class VisitorSignInScreen extends StatefulWidget {
  static final id = '/visitor_sign_in';
  final bool isLoggedIn;
  const VisitorSignInScreen({
    Key key,
    @required this.isLoggedIn,
  }) : super(key: key);

  @override
  _VisitorSignInScreenState createState() => _VisitorSignInScreenState();
}

class _VisitorSignInScreenState extends State<VisitorSignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool hideText = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void successMessage() {
    Fluttertoast.showToast(
      msg: "Sign In Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 600),
    ));
  }

  void signIn() async {
    final _isValid = _formKey.currentState.validate();
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/signin');

    print('validate=$_isValid');
    if (!_isValid) {
      return;
    }
    _formKey.currentState.save();
    var res;
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );
      // print(response.body);
      // print(response.statusCode);
      res = response.body;
      if (response.statusCode == 200 || response.statusCode == 201) {
        //setVisitingFlag();
        setState(() {
          _isLoading = false;
        });
        print('statusCode=${response.statusCode}');
        successMessage();
        Navigator.pushNamed(
          context,
          VisitorHomeScreen.id,
          arguments: {'email': _emailController.text.toString()},
        );
      } else {
        if (jsonDecode(res)['error'] != null) {
          _showSnackBar(jsonDecode(res)['error']);
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (error) {
      // print(error);
      // print('result=$res');
      if (jsonDecode(res)['error'] != null) {
        _showSnackBar(jsonDecode(res)['error']);
      }
      setState(() {
        _isLoading = false;
      });
      throw error;
    }
  }

  Widget resgisterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Don\'t have an account?'),
        SizedBox(
          width: 10.0,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VisitorSignUpScreen()),
            );
          },
          child: Text(
            'Register',
            style:
                TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginButon = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.lightBlueAccent,
      ),
      height: 40.0,
      child: TextButton(
        onPressed: () {
          signIn();
          // Navigator.pushNamed(context, VisitorHomeScreen.id);
        },
        child: Center(
          child: FittedBox(
            child: !_isLoading
                ? Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                : threeBounceSpinkit,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: _appBar(),
      body: _body(context, loginButon),
    );
  }

  Widget _body(BuildContext context, Container loginButon) {
    return WillPopScope(
      onWillPop: () async {
        if (!widget.isLoggedIn) {
          _exitDialog(context);
          // exit(0);
        }

        return false;
      },
      child: Form(
        key: _formKey,
        child: SafeArea(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: double.infinity,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    _emailTextField(),
                    SizedBox(height: 25.0),
                    _passwordField(),
                    SizedBox(height: 5.0),
                    _forgetPassword(context),
                    SizedBox(
                      height: 23.0,
                    ),
                    loginButon,
                    SizedBox(
                      height: 13.0,
                    ),
                    resgisterButton(),
                    SizedBox(
                      height: 13.0,
                    ),
                    // Text(
                    //   'OR Continue with',
                    //   style: TextStyle(color: Colors.black87, fontSize: 18),
                    // ),
                    // SizedBox(
                    //   height: 13.0,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     LoginWithFbBtn(),
                    //     LoginWithGoogleBtn(),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Align _forgetPassword(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () {
          //TODO: Forgot Passwoed button pressed
          Navigator.pushNamed(context, VisitorEnterEmailScreen.id);
        },
        child: Text(
          'Forget Password?',
          style: TextStyle(
            color: Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  AlertDialog _exitDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Exit?',
        style: TextStyle(color: Colors.black),
      ),
      content: Text(
        'Are You Sure You want to exit?',
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Yes"),
          onPressed: () {
            exit(0);
          },
        ),
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Visitor Sign In',
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      obscureText: false,
      controller: _emailController,
      style: loginTextFieldsStyles,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Email';
        } else if (!value.contains('@') || !value.contains('.com')) {
          return 'Email is not valid';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        enabledBorder: border,
        focusedBorder: border,
        prefixIcon: Icon(
          Icons.email,
          color: Colors.grey,
        ),
        border: border,
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      obscureText: hideText,
      controller: _passwordController,
      style: loginTextFieldsStyles,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Password';
        }
        return null;
      },
      decoration: InputDecoration(
          // border: InputBorder.none,
          enabledBorder: border,
          focusedBorder: border,
          border: border,
          // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: "Password",
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  //print('hide');
                  hideText = !hideText;
                });
              },
              icon: Icon(Icons.remove_red_eye))),
    );
  }

  // void setVisitingFlag() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setBool('alreadyVisited', true);
  //   print(preferences);
  // }

  // Future<bool> getVisitingFlag() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   bool alreadyVisited = preferences.getBool('alreadyVisited') ?? false;
  //   return alreadyVisited;
  // }
}
