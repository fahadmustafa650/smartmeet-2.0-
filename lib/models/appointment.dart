import 'package:flutter/foundation.dart';

class PendingAppointment {
  final String id;
  final String visitorId;
  final String employeeId;
  final bool isAccepted = false;
  final String companyName;
  final DateTime date;
  final String timeSlot;
  final String message;
  PendingAppointment({
    @required this.id,
    @required this.visitorId,
    @required this.employeeId,
    @required this.date,
    @required this.timeSlot,
    this.message,
    this.companyName,
  });
}
