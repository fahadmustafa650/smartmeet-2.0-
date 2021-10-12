import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:smart_meet/Constants/constants.dart';
import 'package:smart_meet/Employee/employee_screens/employee_home_screen.dart';
import 'package:smart_meet/Visitor/Visitor%20Authentication/visitor_sign_in_screen.dart';
import 'package:smart_meet/api/firebase_api.dart';
import 'package:path/path.dart';
import 'package:smart_meet/screens/otp_screen.dart';
import 'package:smart_meet/widgets/login_with_fb.dart';
import 'package:smart_meet/widgets/login_with_google.dart';
import 'package:http/http.dart' as http;
import 'package:smart_meet/widgets/term_condition.dart';
import 'package:string_validator/string_validator.dart';

import 'emp_sign_in_screen.dart';

class EmployeeSignUpScreen extends StatefulWidget {
  static final id = '/employee_sign_up';
  @override
  _EmployeeSignUpScreenState createState() => _EmployeeSignUpScreenState();
}

class _EmployeeSignUpScreenState extends State<EmployeeSignUpScreen> {
  //VARIABLES
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userNameController = TextEditingController();
  String imageUrl;
  UploadTask task;
  DateTime _dateOfBirth;
  var isChecked = false;
  // formKey
  final _formKey = GlobalKey<FormState>();
  // File imgFile;
  io.File _image;

  Future<void> uploadFile() async {
    if (_image == null) return;
    final fileName = basename(_image.path);
    final destination = 'files/$fileName';
    try {
      task = FirebaseApi.uploadFile(destination, _image);
    } catch (error) {
      print(error);
    }

    setState(() {});
    if (task == null) return;
    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    imageUrl = urlDownload;

    print('Download-Link: $urlDownload');
  }

  void showMessage(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _addEmployeeData(BuildContext context) async {
    final url = Uri.parse(
        "https://pure-woodland-42301.herokuapp.com/api/employee/signup");

    try {
      //print('uploadfile');
      await uploadFile();
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': _firstNameController.text.toString(),
          'lastName': _lastNameController.text.toString(),
          'email': _emailController.text.toString(),
          'username': _userNameController.text.toString(),
          'password': _passwordController.text.toString(),
          'dateOfBirth': _dateOfBirth.toIso8601String(),
          'avatar': imageUrl,
        }),
      );
      print('responseStatus=${response.body}');
      if (response.statusCode == 200) {
        showMessage('Sign Up Successfully');
        Navigator.pushNamed(context, EmployeeSignInScreen.id);
      }
      if (response.statusCode == 400) {
        final msg = jsonDecode(response.body)['error'];
        showMessage(msg.toString());
      }
      return response;
    } catch (error) {
      print('error occured');
      throw error;
    }
  }

  // Future<int> _isEmailExist(String value) async {
  //   final url = Uri.parse(
  //       'https://pure-woodland-42301.herokuapp.com/api/visitor/verifyemail/$value');
  //   final response = await http.get(url);
  //   return response.statusCode;
  // }

  void _showModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.white,
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile Photo',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _imgFromGallery();
                        Navigator.pop(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.photo, size: 30),
                          Text(
                            'Gallery',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        _imgFromCamera();
                        Navigator.pop(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
                          Text(
                            'Camera',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  String dateErrorMessage = '';
  // Submit Data
  void _submitForm(BuildContext context) async {
    final _isValid = _formKey.currentState.validate();
    print('employee sign up 1');
    if (_dateOfBirth == null) {
      setState(() {
        dateErrorMessage = 'Date Not Selected';
      });
    }
    if (_image == null || imageUrl == null) {
      setState(() {
        profilePicError = 'Add Profile Picture';
      });
    }
    if (!_isValid || !isChecked || _image == null) {
      return;
    }
    _formKey.currentState.save();
    print('uploadfile');
    await _addEmployeeData(context);
    print('data added');
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => OtpScreen(
    //       email: _emailController.text.toString(),
    //       addAllData: _addEmployeeData,
    //     ),
    //   ),
    // );
  }

  void _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = io.File(image.path);
    });
  }

  void _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = io.File(image.path);
      profilePicError = '';
    });
  }

  var errorPassword = '';
  var profilePicError = '';
  bool _isDateSelected = false;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Employee Sign Up',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 1.8,
            child: Stack(
              children: [
                BackgroundUpperContainer(),
                Positioned(
                  left: 10.0,
                  top: 60.0,
                  right: 10.0,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 50.0),
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          spreadRadius: 1.0,
                          blurRadius: 3.0,
                        )
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 20.0),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  _showModalBottomSheet(context);
                                },
                                child: Container(
                                  width: 128,
                                  height: 128,
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 128,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: _image != null
                                            ? FileImage(_image)
                                            : AssetImage(
                                                'assets/images/blank_pic.jpg'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              _image == null ? profilePicError : '',
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: TextFormField(
                                      controller: _firstNameController,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please Enter a name';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'First Name',
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                        border: InputBorder.none,
                                        fillColor: Colors.grey[100],
                                        filled: true,
                                        prefixIcon: Icon(
                                          FontAwesomeIcons.userAlt,
                                          color: Colors.grey,
                                          size: 15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: TextFormField(
                                      controller: _lastNameController,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please Enter a name';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Last Name',
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                        border: InputBorder.none,
                                        fillColor: Colors.grey[100],
                                        filled: true,
                                        prefixIcon: Icon(
                                          FontAwesomeIcons.userAlt,
                                          color: Colors.grey,
                                          size: 15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: TextFormField(
                                controller: _userNameController,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter a value';
                                  } else if (!isAlphanumeric(value)) {
                                    return 'Username must contain both alpha & numeric characters';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'User Name',
                                  labelStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  border: InputBorder.none,
                                  fillColor: Colors.grey[100],
                                  filled: true,
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.userAlt,
                                    color: Colors.grey,
                                    size: 15.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: TextFormField(
                                obscureText: false,
                                style: loginTextFieldsStyles,
                                textInputAction: TextInputAction.next,
                                controller: _emailController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please Enter Email";
                                  } else if (!value.contains('@') ||
                                      !value.contains('.com')) {
                                    return 'Please Enter valid Email';
                                  }
                                  // } else if (_isEmailExist(value) == 200) {
                                  //   return 'Already Register with this account';
                                  // }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.grey[100],
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: ListTile(
                                onTap: () async {
                                  await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1870),
                                          lastDate: DateTime.now())
                                      .then((date) {
                                    setState(() {
                                      _dateOfBirth = date;
                                      _isDateSelected = true;
                                      // print('date=$_dateOfBirth');
                                    });
                                  });
                                },
                                tileColor: Colors.grey[100],
                                leading: Text(
                                  _dateOfBirth == null
                                      ? 'Tap To Enter DOB'
                                      : DateFormat.yMMMMd('en_US')
                                          .format(_dateOfBirth),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                trailing: Icon(FontAwesomeIcons.calendarAlt),
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  !_isDateSelected ? '' : dateErrorMessage,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12.0),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: TextFormField(
                                controller: _phoneNumberController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please Enter Phone No";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.grey[100],
                                  filled: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.fromLTRB(
                                    20.0,
                                    15.0,
                                    20.0,
                                    15.0,
                                  ),
                                  labelText: 'Phone No',
                                  labelStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: TextFormField(
                                obscureText: true,
                                style: loginTextFieldsStyles,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.visiblePassword,
                                controller: _passwordController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please Enter Password";
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.fromLTRB(
                                      20.0,
                                      15.0,
                                      20.0,
                                      15.0,
                                    ),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Colors.grey,
                                    ),
                                    suffixIcon: Icon(Icons.remove_red_eye)),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: TextFormField(
                                obscureText: true,
                                style: loginTextFieldsStyles,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.visiblePassword,
                                controller: _confirmPasswordController,
                                onChanged: (value) {
                                  if (value !=
                                      _passwordController.text.toString()) {
                                    setState(() {
                                      errorPassword = "Password Doesn't Match";
                                    });
                                  }
                                  if (value ==
                                      _passwordController.text.toString()) {
                                    setState(() {
                                      errorPassword = "";
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please Enter Password";
                                  } else if (value !=
                                      _passwordController.text.toString()) {
                                    return "Those passwords didn’t match. Try again.";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.grey[100],
                                  filled: true,
                                  //errorText: errorPassword,
                                  errorStyle: TextStyle(
                                      color: Colors.red, fontSize: 14),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.fromLTRB(
                                    20.0,
                                    15.0,
                                    20.0,
                                    15.0,
                                  ),
                                  labelText: 'Confirm Password',
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.remove_red_eye,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            ListTile(
                              leading: TermsCondition(),
                              trailing: Checkbox(
                                value: isChecked,
                                onChanged: (bool value) {
                                  setState(() {
                                    isChecked = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 23.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                color: Colors.lightBlueAccent,
                              ),
                              height: 40.0,
                              child: TextButton(
                                onPressed: () {
                                  _submitForm(context);
                                },
                                child: Center(
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 13.0,
                            ),
                            AlreadyAccount(),
                            SizedBox(
                              height: 13.0,
                            ),
                            // Text(
                            //   'OR Continue with',
                            //   style: TextStyle(
                            //       color: Colors.black87, fontSize: 18),
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
                            SizedBox(
                              height: 13.0,
                            ),
                            Text(
                              'OR Sign Up with',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 13.0,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: screenWidth * 0.4,
                                height: screenHeight * 0.2,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 5, color: Colors.black)),
                                child: Image(
                                  image:
                                      AssetImage('assets/images/ocr_logo.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 13.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlreadyAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already Have an Account? ",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmployeeSignInScreen()),
            );
          },
          child: Text(
            "Login",
            style: TextStyle(
                color: Colors.lightBlueAccent, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

class BackgroundUpperContainer extends StatelessWidget {
  const BackgroundUpperContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: double.infinity,
      color: Colors.lightBlueAccent,
      child: Align(
        alignment: Alignment.topCenter,
        child: Image(
          width: 200,
          color: Colors.white,
          image: AssetImage(
            'assets/images/logo.png',
          ),
        ),
      ),
    );
  }
}
