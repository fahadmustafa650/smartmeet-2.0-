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
  static final id = '/employee_pending_screen';
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

  // Future<void> _fetchRunInAppointmentsData() async {
  //   print('fetching Run In Appointmnet data');
  //   try {
  //     // final employeeId = Provider.of<EmployeesProvider>(context).getEmployee.id;
  //     print('e1');
  //     final employeeId = '6160912d9ddfb800041e6fd5';
  //     print('e2');
  //     if (employeeId == null) return;
  //     print('e3');
  //     await Provider.of<EmployeePendingAppointmentsRequestsProvider>(
  //       context,
  //       listen: false,
  //     ).pendingRunInAppointmentRequestsList(employeeId).then((_) {
  //       allAppointmentsData();
  //     });
  //     print('e4');
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  Future<void> _allAppointmentsData() async {
    print('fetching All data');
    print('isLoading: $_isLoading');
    //print();
    // ignore: unnecessary_statements
    Provider.of<EmployeePendingAppointmentsRequestsProvider>(context,
            listen: false)
        .allPendingAppointmentsList();

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
            .getAllAppointments;
    // final int runInAppointmentLength =
    //     Provider.of<EmployeePendingAppointmentsRequestsProvider>(context,
    //             listen: false)
    //         .getPendingRunInAppointmentRequests
    //         .length;
    return RefreshIndicator(
      onRefresh: _fetchAppointmentPendingData,
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
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _allAppointmentsList.length == 0
                ? Center(
                    child: Text('No Pending Requests'),
                  )
                : Consumer<EmployeePendingAppointmentsRequestsProvider>(
                    // stream: null,
                    builder: (ctx, pendingAppointments, child) {
                    return ListView.builder(
                      itemCount: _allAppointmentsList.length,
                      itemBuilder: (ctx, index) {
                        return VisitorAppointmentRequest(
                          visitorAppointmentRequestData:
                              pendingAppointments.getAllAppointments[index],
                          isUrgent: pendingAppointments
                              .getAllAppointments[index].isUrgent,
                          index: index,
                        );
                      },
                    );
                  }),
      ),
    );
  }
}
