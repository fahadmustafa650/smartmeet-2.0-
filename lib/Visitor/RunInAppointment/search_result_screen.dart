import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_meet/Visitor/Appointment/request_appoinment_screen.dart';
import 'package:smart_meet/models/employee_model.dart';
import 'package:smart_meet/models/runInAppointment_model.dart';
import 'run_in_appointment_screen.dart';
import 'search_employee_screen.dart';
import 'package:http/http.dart' as http;

class EmployeeSearchResultScreen extends StatefulWidget {
  static final id = '/employee_result_screen';
  final String name;
  const EmployeeSearchResultScreen({
    @required this.name,
  });
  @override
  _EmployeeSearchResultScreenState createState() =>
      _EmployeeSearchResultScreenState();
}

class _EmployeeSearchResultScreenState
    extends State<EmployeeSearchResultScreen> {
  var _isInit = false;
  bool _isLoading = true;
  bool _isDataExist = true;
  List<Employee> _searchResultList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isInit = true;
    _isLoading = true;
  }

  void _fetchData() async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/searchEmployees/${widget.name}');

    final response = await http.get(url);
    final responseData = jsonDecode(response.body);
    //print(responseData['message']);
    if (response.statusCode == 400) {
      print('statusCode=${response.statusCode}');
      setState(() {
        _isDataExist = false;
        _isLoading = false;
      });
    } else if (response.statusCode == 200) {
      print('responded');
      final extractedData = await responseData as List<dynamic>;
      extractedData.forEach((value) {
        _searchResultList.add(
          Employee(
            id: value['_id'],
            firstName: value['firstName'],
            lastName: value['lastName'],
            username: value['username'],
            email: value['email'],
            dateOfBirth: DateTime.parse(value['dateOfBirth']),
            imageUrl: value['avatar'],
          ),
        );
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _fetchData();
        _isInit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Result'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : !_isDataExist
              ? Center(
                  child: Text(
                    'No Data Found',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : ListView.builder(
                  itemCount: _searchResultList.length,
                  itemBuilder: (ctx, index) {
                    return EmployeeInfoContainer(
                      employeeData: _searchResultList[index],
                    );
                  },
                  // children: [

                  // ],
                ),
    );
  }
}

class EmployeeInfoContainer extends StatelessWidget {
  final Employee employeeData;
  const EmployeeInfoContainer({
    @required this.employeeData,
  });

  @override
  Widget build(BuildContext context) {
    final name = '${employeeData.firstName} ${employeeData.lastName}';
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    return Container(
        width: screenWidth * 0.9,
        margin:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10),
        height: 150,
        child: Card(
          elevation: 3,
          child: Row(
            children: [
              Image(
                image: NetworkImage(employeeData.imageUrl),
              ),
              SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'jobTitle',
                    style: TextStyle(color: Colors.transparent, fontSize: 14),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RunInAppointmentScreen(
                            employeeId: employeeData.id,
                          ),
                        ),
                      );
                      // Navigator.pushNamed(context, RunInAppointmentScreen.id,
                      //     arguments: {
                      //       'employeeId': employeeData.id,
                      //     });
                    },
                    child: Container(
                      width: screenWidth * 0.45,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Center(
                          child: Text(
                        'Book an Appointment',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
