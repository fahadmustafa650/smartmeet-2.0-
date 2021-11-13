import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_meet/Constants/constants.dart';
import 'package:smart_meet/Visitor/Appointment/visitor_pending_appointments_screen.dart';
import 'package:smart_meet/Visitor/Appointment/search_employee_screen.dart';
import 'package:smart_meet/Visitor/Visitor%20Authentication/visitor_sign_in_screen.dart';
import 'package:smart_meet/models/visitor_model.dart';
import 'package:smart_meet/providers/visitor_provider.dart';
import 'package:smart_meet/screens/chat_screen.dart';
import 'package:smart_meet/screens/edit_profile_screen.dart';
import 'package:smart_meet/screens/login_as_screen.dart';
import 'package:smart_meet/widgets/info_panel.dart';
import 'Appointment/visitor_booked_appointment_screen.dart';
import 'Visitor Authentication/visitor_edit_profile_screen.dart';

class VisitorHomeScreen extends StatefulWidget {
  static final id = '/visitor_home_screen';

  @override
  _VisitorHomeScreenState createState() => _VisitorHomeScreenState();
}

class _VisitorHomeScreenState extends State<VisitorHomeScreen> {
  bool _isInit;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //successMessage();

    _isInit = true;
    // _isInit = false;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (_isInit &&
        Provider.of<VisitorProvider>(context).getVisitor.id == null) {
      //await Provider.of<Visitors>(context).getVisitorData(args['email']);
      setState(() {
        _isLoading = true;
      });
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      await Provider.of<VisitorProvider>(context)
          .getVisitorDataByEmail(args['email']);
    }
    setState(() {
      _isInit = false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visitorData =
        Provider.of<VisitorProvider>(context, listen: true).getVisitor;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      drawer: !_isLoading
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.all(0),
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountEmail: visitorData.email == null
                        ? threeBounceSpinkit
                        : Text(visitorData.email),
                    accountName: (visitorData.firstName == null ||
                            visitorData.lastName == null)
                        ? threeBounceSpinkit
                        : Text(
                            '${visitorData.firstName} ${visitorData.lastName}'),
                    currentAccountPicture: _isLoading
                        ? threeBounceSpinkit
                        : CircleAvatar(
                            radius: 100,
                            backgroundImage: _isLoading
                                ? AssetImage('assets/images/blank_pic.jpg')
                                : NetworkImage(visitorData.imageUrl),
                          ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Edit Profile"),
                    onTap: () {
                      Navigator.pushNamed(context, VisitorEditProfileScreen.id);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.dashboard),
                    title: Text("Book Appointment"),
                    onTap: () {
                      // print("Categories Clicked");
                      Navigator.pushNamed(context, EmployeeSearchBar.id);
                    },
                  ),
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
                      logOut(context);
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
                ('${visitorData.firstName} ${visitorData.lastName}'),
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
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, EmployeeSearchBar.id);
            },
            child: InfoPanel(
              title: 'Book Appointment',
              textIconColor: Colors.yellow[900],
              iconData: Icons.approval,
            ),
          ),
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
              Navigator.pushNamed(context, BookedAppointmentsScreen.id);
            },
            child: InfoPanel(
                title: 'Booked\nAppointments',
                textIconColor: Colors.yellow[800],
                iconData: FontAwesomeIcons.addressCard),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, VisitorPendingAppointmentsScreen.id);
            },
            child: InfoPanel(
              title: 'Pending\nAppointments',
              textIconColor: Colors.blue,
              iconData: Icons.person,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, VisitorEditProfileScreen.id);
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
              iconData: Icons.report,
            ),
          ),
          GestureDetector(
            onTap: () {
              print('logout');
              logOut(context);
              //clearLoginData();
              //Navigator.push(context, );
              // Navigator.pushNamed(context, VisitorSignInScreen.id);
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
    final visitorData = Provider.of<VisitorProvider>(context, listen: false);
    visitorData.destroyVisitor();
    if (visitorData.getVisitor.id == null) {
      Fluttertoast.showToast(
          msg: "Logout Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      //print('loggedouttt');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VisitorSignInScreen(
            isLoggedIn: false,
          ),
        ),
      );
    }
  }

  // void clearLoginData() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   await preferences.clear();
  // }
}
