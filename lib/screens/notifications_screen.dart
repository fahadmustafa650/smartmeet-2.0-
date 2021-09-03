import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:smart_meet/models/appointment_request_model.dart';
import 'package:smart_meet/providers/appointments_provider.dart';
import 'package:smart_meet/providers/employee_provider.dart';
import 'package:smart_meet/widgets/appointment_request.dart';

class Notifications extends StatefulWidget {
  static final id = '/notifications_screen';

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool _isLoading = true;
  List<PendingAppointment> appointmentPendingRequests;
  Future<void> _fetchAppointmentPendingData() async {
    try {
      //  final id = Provider.of<EmployeesProvider>(context).getEmployee.id;
      final employeeId = '612c967d21b51e000445207d';

      if (employeeId == null) return;

      final response = await Provider.of<PendingAppointmentsRequestsProvider>(
              context,
              listen: false)
          .pendingAppointmentRequestsList(employeeId)
          .then((value) {
        appointmentPendingRequests =
            Provider.of<PendingAppointmentsRequestsProvider>(context,
                    listen: false)
                .getPendingAppointmentRequests;
        setState(() {
          _isLoading = false;
        });
      });

      //print(appointmentPendingRequests.length);

    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchAppointmentPendingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: appointmentPendingRequests.length,
              itemBuilder: (ctx, index) {
                return AppointmentRequest(
                  appointmentRequestData: appointmentPendingRequests[index],
                );
              }),
    );
  }
}
