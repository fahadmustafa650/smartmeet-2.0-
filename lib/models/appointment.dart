import 'package:flutter/foundation.dart';

class Appointment {
  final String id;
  final String visitorId;
  final String employeeId;
  final String companyName;
  final DateTime date;
  final String timeSlot;
  final String message;
  Appointment({
    @required this.id,
    @required this.visitorId,
    @required this.employeeId,
    @required this.date,
    @required this.timeSlot,
    this.message,
    this.companyName,
  });
}
