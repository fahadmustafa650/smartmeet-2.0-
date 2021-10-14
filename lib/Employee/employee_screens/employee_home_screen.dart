import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_meet/Constants/constants.dart';
import 'package:smart_meet/Employee/employee_screens/emp_sign_in_screen.dart';
import 'package:smart_meet/Employee/employee_screens/employee_pending_appointments_screen.dart';
import 'package:smart_meet/models/employee_model.dart';
import 'package:smart_meet/providers/employee_provider.dart';
import 'package:smart_meet/screens/chat_screen.dart';
import 'package:smart_meet/screens/login_as_screen.dart';
import 'package:smart_meet/widgets/info_panel.dart';
import 'package:smart_meet/Employee/employee_screens/employee_booked_appointment.dart';

import 'employee_edit_profile_screen.dart';

class EmployeeHomeScreen extends StatefulWidget {
  static final id = '/employee_home_screen';

  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  bool _isInit;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _isInit = true;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    print(
        'isInit=$_isInit id=${Provider.of<EmployeesProvider>(context).getEmployee.id}');
    if (_isInit &&
        Provider.of<EmployeesProvider>(context).getEmployee.id == null) {
      setState(() {
        _isLoading = true;
      });
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      await Provider.of<EmployeesProvider>(context)
          .getEmployeeDataByEmail(args['email']);
    }
    setState(() {
      _isInit = false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeeData =
        Provider.of<EmployeesProvider>(context, listen: true).getEmployee;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      drawer: !_isLoading
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.all(0),
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountEmail: employeeData.email == null
                        ? CircularProgressIndicator()
                        : Text(employeeData.email),
                    accountName: employeeData.firstName == null ||
                            employeeData.lastName == null
                        ? CircularProgressIndicator()
                        : Text(
                            '${employeeData.firstName} ${employeeData.lastName}'),
                    currentAccountPicture: _isLoading
                        ? CircularProgressIndicator()
                        : CircleAvatar(
                            radius: 100,
                            backgroundImage: _isLoading
                                ? AssetImage('assets/images/blank_pic.jpg')
                                : NetworkImage(employeeData.imageUrl),
                          ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Edit Profile"),
                    onTap: () {
                      Navigator.pushNamed(
                          context, EmployeeEditProfileScreen.id);
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.dashboard),
                  //   title: Text("Book Appointment"),
                  //   onTap: () {
                  //     // print("Categories Clicked");
                  //   },
                  // ),
                  ListTile(
                    leading: Icon(Icons.add_to_photos),
                    title: Text("Reports"),
                    onTap: () {
                      //print("Add Clicked");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.message),
                    title: Text("Chat"),
                    onTap: () {
                      Navigator.pushNamed(context, ChatScreen.id);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                    ),
                    title: Text("Logout"),
                    onTap: () {
                      Navigator.pushNamed(context, LoginAsScreen.id);
                    },
                  ),
                ],
              ),
            )
          : Container(),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: _isLoading
            ? threeBounceSpinkit
            : Text(
                ('${employeeData.firstName} ${employeeData.lastName}'),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 25,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        children: [
          // GestureDetector(
          //   onTap: () {
          //     //  Navigator.pushNamed(context, EmployeeSearchBar.id);
          //   },
          //   child: InfoPanel(
          //     title: 'Booked Appointment',
          //     textIconColor: Colors.yellow[900],
          //     iconData: Icons.approval,
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ChatScreen.id);
            },
            child: InfoPanel(
              // bgColor: Color(0XFFA1F8AF).withOpacity(0.4),
              title: 'Chat',
              textIconColor: Colors.green[400],
              iconData: Icons.chat,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, EmployeeBookedAppointmentsScreen.id);
            },
            child: InfoPanel(
              title: 'Booked\nAppointments',
              textIconColor: Colors.yellow[800],
              iconData: FontAwesomeIcons.addressCard,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, EmployeePendingAppointmentsScreen.id);
            },
            child: InfoPanel(
              title: 'Pending\nAppointments',
              textIconColor: Colors.blue,
              iconData: Icons.person,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, EmployeeEditProfileScreen.id);
            },
            child: InfoPanel(
              title: 'Edit Profile',
              textIconColor: Colors.blue,
              iconData: Icons.person,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: InfoPanel(
                title: 'Reports',
                textIconColor: Colors.black,
                iconData: Icons.report),
          ),
          GestureDetector(
            onTap: () {
              logOut(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => MXPSchoolPickup()));
              //clearLoginData();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => EmployeeSignInScreen(
              //       isLoggedIn: false,
              //     ),
              //   ),
              // );
            },
            child: InfoPanel(
              title: 'Logout',
              textIconColor: Colors.red,
              iconData: Icons.logout,
            ),
          )
        ],
      ),
    );
  }

  void logOut(BuildContext context) {
    final employeeData = Provider.of<EmployeesProvider>(context, listen: false);
    print('logout');
    employeeData.destroyEmployee();
    print('empId=${employeeData.getEmployee.id}');
    if (employeeData.getEmployee.id == null) {
      Fluttertoast.showToast(
        msg: "Logout Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      //print('loggedouttt');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmployeeSignInScreen(
            isLoggedIn: false,
          ),
        ),
      );
    }
  }

  void clearLoginData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
