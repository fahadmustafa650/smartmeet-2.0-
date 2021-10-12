import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_meet/Constants/constants.dart';
import 'package:smart_meet/Visitor/visitor_home_screen.dart';
import 'package:smart_meet/models/employee_model.dart';
import 'package:smart_meet/models/visitor_model.dart';
import 'package:smart_meet/providers/employee_provider.dart';
import 'package:smart_meet/providers/visitor_provider.dart';
import 'package:http/http.dart' as http;
import 'package:smart_meet/api/firebase_api.dart';

class VisitorEditProfileScreen extends StatelessWidget {
  static final id = '/visitor_edit_profile_screen';
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
  bool _isLoading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then(
    //   (_) {
    //     // print('fName=${visitorData.firstName.toString()}');
    //     // print('lName=${visitorData.lastName.toString()}');
    //   },
    // );
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

    setState(() {
      _isLoading = true;
    });

    if (task == null) return;
    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    _imageUrl = urlDownload;

    // print('Download-Link: $urlDownload');
  }

  void updateForm() {
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
    final visitorData = Provider.of<VisitorProvider>(context, listen: true);

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
                          child: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.camera_alt,
                              size: 25,
                            ),
                          )),
                      CircleAvatar(
                        radius: 128,
                        backgroundImage: visitorData.getVisitor.imageUrl != null
                            ? NetworkImage(visitorData.getVisitor.imageUrl)
                            : AssetImage('assets/images/blank_pic.jpg'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      obscureText: false,
                      style: loginTextFieldsStyles,
                      //controller: _firstNameControlller,
                      initialValue: '${visitorData.getVisitor.firstName}',
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
                        focusedBorder: border,
                        enabledBorder: border,
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
                      initialValue: '${visitorData.getVisitor.lastName}',
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
                        focusedBorder: border,
                        enabledBorder: border,
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
                    child: _isLoading == true
                        ? threeBounceSpinkit
                        : Text(
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
    final visitorData = Provider.of<VisitorProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    await uploadFile();
    final visitor = Visitor(
      firstName:
          _firstName == null ? visitorData.getVisitor.firstName : _firstName,
      lastName: _lastName == null ? visitorData.getVisitor.lastName : _lastName,
      imageUrl: _imageUrl == null ? visitorData.getVisitor.imageUrl : _imageUrl,
      id: visitorData.getVisitor.id,
      dateOfBirth: visitorData.getVisitor.dateOfBirth,
      username: visitorData.getVisitor.username,
      email: visitorData.getVisitor.email,
    );

    visitorData.updateVisitorData(visitor).then((value) {
      print('updateVisitorData=$value');
      if (value == 200) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushNamed(context, VisitorHomeScreen.id);
      } else {
        Navigator.pushNamed(context, VisitorHomeScreen.id);
      }
    });

    // final response = await http.put(
    //   url,
    //   headers: <String, String>{
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'id': visitorData.getVisitor.id,
    //     'firstName':
    //         _firstName == null ? visitorData.getVisitor.firstName : _firstName,
    //     'lastName':
    //         _lastName == null ? visitorData.getVisitor.lastName : _lastName,
    //     'avatar':
    //         _imageUrl == null ? visitorData.getVisitor.imageUrl : _imageUrl,
    //   }),
    // );
    // print('id=${visitorData.getVisitor.id}');
    // print('fName=${visitorData.getVisitor.firstName}');
    // print('lName=${visitorData.getVisitor.lastName}');
    // print('codee=${response.statusCode}');
    // print('body=${response.body}');
    // if (response.statusCode == 200) {
    //   visitorData.getVisitorDataById(visitorData.getVisitor.id);
    //   Fluttertoast.showToast(
    //     msg: "Data Updated Successfully",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.black54,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );
    //   setState(() {
    //     _isLoading = false;
    //   });

    // }
  }
}
