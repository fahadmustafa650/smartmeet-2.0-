import 'package:flutter/material.dart';

class SentAppointment {
  final String id;
  final String employeeId;
  final String visitorId;
  final String companyName;
  final DateTime date;
  final String timeSlot;
  final String message;
  final bool isAccepted;
  SentAppointment({
    @required this.id,
    @required this.employeeId,
    @required this.visitorId,
    @required this.companyName,
    @required this.date,
    @required this.timeSlot,
    @required this.message,
    @required this.isAccepted,
  });
}
