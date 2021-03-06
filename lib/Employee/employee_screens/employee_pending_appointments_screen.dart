import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_meet/models/appointment.dart';
import 'package:smart_meet/models/runInAppointment_model.dart';
// import 'package:smart_meet/models/visitor_appointment_request_model.dart';
import 'package:smart_meet/providers/employee_pending_appointments_provider.dart';
import 'package:smart_meet/providers/employee_provider.dart';
// import 'package:smart_meet/providers/employee_provider.dart';
import 'package:smart_meet/widgets/appointment_request.dart';

class EmployeePendingAppointmentsScreen extends StatefulWidget {
  static final id = '/employee_pending_Appointment_screen';
  final String employeeId;

  const EmployeePendingAppointmentsScreen({
    @required this.employeeId,
  });

  @override
  _EmployeePendingAppointmentsScreenState createState() =>
      _EmployeePendingAppointmentsScreenState();
}

class _EmployeePendingAppointmentsScreenState
    extends State<EmployeePendingAppointmentsScreen> {
  bool _isLoading = true;
  var _isInit = false;
  // List<Appointment> _appointmentPendingRequestsList;
  // List<RunInAppointment> _runInAppointmentList;
  List<dynamic> _allAppointmentsList = [];
  //var _isFetch = true;

  // bool isUrgent = false;
  Future<void> _fetchAppointmentPendingData() async {
    print('fetching Appoint data');
    try {
      // final employeeId = Provider.of<EmployeesProvider>(context).getEmployee.id;
      final employeeId = '6160912d9ddfb800041e6fd5';
      if (employeeId == null) return;
      await Provider.of<EmployeePendingAppointmentsRequestsProvider>(
        context,
        listen: false,
      ).pendingAppointmentRequestsList(employeeId).then(
        (value) {
          _allAppointmentsData();
          //_fetchRunInAppointmentsData();
          // setState(() {
          //   _isLoading = false;
          // });
        },
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> _allAppointmentsData() async {
    print('fetching All data');
    print('isLoading: $_isLoading');
    //print();
    // ignore: unnecessary_statements
    Provider.of<EmployeePendingAppointmentsRequestsProvider>(context,
            listen: false)
        .pendingAppointmentRequestsList;

    print('All Appointments = $_allAppointmentsList');
    _allAppointmentsList.forEach((element) {
      print(element);
    });
    //print('allA');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _isInit = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _fetchAppointmentPendingData();

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _allAppointmentsList =
        Provider.of<EmployeePendingAppointmentsRequestsProvider>(context,
                listen: true)
            .getPendingAppointmentRequests;
    // final int runInAppointmentLength =
    //     Provider.of<EmployeePendingAppointmentsRequestsProvider>(context,
    //             listen: false)
    //         .getPendingRunInAppointmentRequests
    //         .length;
    return RefreshIndicator(
      onRefresh: _fetchAppointmentPendingData,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Text(
              'Pending Appointments',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            bottom: TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text: 'Appointments',
                ),
                Tab(
                  text: 'Urgent',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SimpleAppointmentsTab(),
              UrgentAppointmentsTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleAppointmentsTab extends StatefulWidget {
  @override
  _SimpleAppointmentsTabState createState() => _SimpleAppointmentsTabState();
}

class _SimpleAppointmentsTabState extends State<SimpleAppointmentsTab> {
  bool _isLoading = true;
  var _isInit = false;
  //List<Appointment> _allSimpleAppointmentsList = [];

  // Future<void> _allAppointmentsData() {
  //   print('fetching All data');
  //   print('isLoading: $_isLoading');
  //   //print();
  //   Provider.of<EmployeePendingAppointmentsRequestsProvider>(context,
  //           listen: false)
  //       .allPendingAppointmentsList();

  //   // print('All Appointments = $_allSimpleAppointmentsList');
  //   // _allSimpleAppointmentsList.forEach((element) {
  //   //   print(element);
  //   // });
  //   //print('allA');
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  Future<void> _fetchAppointmentPendingData() async {
    print('fetching Appoint data');
    try {
      // final employeeId = Provider.of<EmployeesProvider>(context).getEmployee.id;
      final employeeId = '6160912d9ddfb800041e6fd5';
      if (employeeId == null) return;
      await Provider.of<EmployeePendingAppointmentsRequestsProvider>(
        context,
        listen: false,
      ).pendingAppointmentRequestsList(employeeId).then(
        (_) {
          //_allAppointmentsData();
          //_fetchRunInAppointmentsData();
          setState(() {
            _isLoading = false;
          });
        },
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
    _isInit = true;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      _fetchAppointmentPendingData();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _allSimpleAppointmentsList =
        Provider.of<EmployeePendingAppointmentsRequestsProvider>(context,
                listen: true)
            .getPendingAppointmentRequests;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _allSimpleAppointmentsList.length == 0
            ? Center(child: Text('No Pending Appointments'))
            : ListView.builder(
                itemCount: _allSimpleAppointmentsList.length,
                itemBuilder: (ctx, index) {
                  return VisitorAppointmentRequest(
                    visitorAppointmentRequestData:
                        _allSimpleAppointmentsList[index],
                    isUrgent: _allSimpleAppointmentsList[index].isUrgent,
                    // index: index,
                  );
                },
              );
  }
}

class UrgentAppointmentsTab extends StatefulWidget {
  @override
  _UrgentAppointmentsTabState createState() => _UrgentAppointmentsTabState();
}

class _UrgentAppointmentsTabState extends State<UrgentAppointmentsTab> {
  bool _isLoading = true;
  var _isInit = false;

  Future<void> _fetchAppointmentPendingData() async {
    print('fetching Appoint data');
    try {
      // final employeeId = Provider.of<EmployeesProvider>(context).getEmployee.id;
      final employeeId = '6160912d9ddfb800041e6fd5';
      if (employeeId == null) return;
      await Provider.of<EmployeePendingAppointmentsRequestsProvider>(
        context,
        listen: false,
      ).pendingAppointmentRequestsList(employeeId).then(
        (_) {
          //_allAppointmentsData();
          //_fetchRunInAppointmentsData();
          setState(() {
            _isLoading = false;
          });
        },
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
    _isInit = true;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      _fetchAppointmentPendingData();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _allUrgentAppointmentRequests =
        Provider.of<EmployeePendingAppointmentsRequestsProvider>(context,
                listen: true)
            .getPendingRunInAppointmentRequests;
    print('urgentAppointments=$_allUrgentAppointmentRequests');
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _allUrgentAppointmentRequests.length == 0
            ? Center(child: Text('No Pending Appointments'))
            : ListView.builder(
                itemCount: _allUrgentAppointmentRequests.length,
                itemBuilder: (ctx, index) {
                  return VisitorAppointmentRequest(
                    visitorAppointmentRequestData:
                        _allUrgentAppointmentRequests[index],
                    isUrgent: _allUrgentAppointmentRequests[index].isUrgent,
                    //index: index,
                  );
                },
              );
  }
}
