import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as p;
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_meet/Constants/constants.dart';
import 'package:smart_meet/Employee/employee_screens/employee_home_screen.dart';
import 'package:smart_meet/Visitor/visitor_home_screen.dart';
import 'package:smart_meet/models/employee_model.dart';
import 'package:smart_meet/providers/employee_provider.dart';
import 'package:smart_meet/providers/visitor_provider.dart';
import 'package:http/http.dart' as http;
import 'package:smart_meet/api/firebase_api.dart';

class EmployeeEditProfileScreen extends StatelessWidget {
  static final id = '/employee_edit_profile_screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 10),
            // height: MediaQuery.of(context).size.height * 1,
            // decoration: BoxDecoration(
            //   color: Colors.white,
            // ),
            child: EditProfileForm(),
          ),
        ),
      ),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  File _image;
  String _imageUrl;
  UploadTask task;
  String _firstName;
  String _lastName;

  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (_) {
        // print('fName=${visitorData.firstName.toString()}');
        // print('lName=${visitorData.lastName.toString()}');
      },
    );
    super.initState();
  }

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
    _imageUrl = urlDownload;

    print('Download-Link: $urlDownload');
  }

  void _updateForm() {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      //TODO: Enter Backend code to submit form
      print('valid');
    }
  }

  void _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
  }

  void _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final employeeData = Provider.of<EmployeesProvider>(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => _showModalBottomSheet(context),
              child: Center(
                child: Container(
                  width: 128,
                  height: 128,
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.camera_alt,
                            size: 25,
                          )),
                      CircleAvatar(
                        radius: 128,
                        backgroundImage: employeeData.getEmployee.imageUrl !=
                                null
                            ? NetworkImage(employeeData.getEmployee.imageUrl)
                            : AssetImage('assets/images/blank_pic.jpg'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    obscureText: false,
                    style: loginTextFieldsStyles,
                    //controller: _firstNameControlller,
                    initialValue: '${employeeData.getEmployee.firstName}',
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter Text";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _firstName = value;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      // hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextFormField(
                    obscureText: false,
                    style: loginTextFieldsStyles,
                    //controller: _lastNameControlller,
                    initialValue: '${employeeData.getEmployee.lastName}',
                    onChanged: (value) {
                      _lastName = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter Text";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      //hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                updateProfile(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  void updateProfile(BuildContext context) async {
    final employeeData = Provider.of<EmployeesProvider>(context, listen: false);

    await uploadFile();
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/employee/updateProfile');

    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'id': employeeData.getEmployee.id,
        'firstName': _firstName == null
            ? employeeData.getEmployee.firstName
            : _firstName,
        'lastName':
            _lastName == null ? employeeData.getEmployee.lastName : _lastName,
        'avatar':
            _imageUrl == null ? employeeData.getEmployee.imageUrl : _imageUrl,
      }),
    );
    print('code=${response.statusCode}');
    if (response.statusCode == 200) {
      employeeData.getEmployeeDataById(employeeData.getEmployee.id);
      Fluttertoast.showToast(
          msg: "Data Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushNamed(context, EmployeeHomeScreen.id);
    }
  }
}
