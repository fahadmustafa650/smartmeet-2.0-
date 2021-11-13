import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_meet/models/appointment.dart';
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
  List<Appointment> _appointmentPendingRequestsList;

  Future<void> _fetchAppointmentPendingData() async {
    try {
      final employeeId = Provider.of<EmployeesProvider>(context).getEmployee.id;
      //final employeeId = '6160912d9ddfb800041e6fd5';
      if (employeeId == null) return;
      await Provider.of<EmployeePendingAppointmentsRequestsProvider>(
        context,
        listen: false,
      ).pendingAppointmentRequestsList(employeeId).then(
        (value) {
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
    // TODO: implement initState
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
    _appointmentPendingRequestsList =
        Provider.of<EmployeePendingAppointmentsRequestsProvider>(context,
                listen: true)
            .getPendingAppointmentRequests;
    return Scaffold(
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
          : _appointmentPendingRequestsList.length == 0
              ? Center(
                  child: Text('No Pending Requests'),
                )
              : ListView.builder(
                  itemCount: _appointmentPendingRequestsList.length,
                  itemBuilder: (ctx, index) {
                    return VisitorAppointmentRequest(
                      visitorAppointmentRequestData:
                          _appointmentPendingRequestsList[index],
                    );
                  },
                ),
    );
  }
}
