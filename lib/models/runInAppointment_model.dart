import 'package:flutter/foundation.dart';

class RunInAppointment {
  final String id;

  final String employeeId;
  final String visitorName;
  final String visitorEmail;
  final String visitorPhone;
  final String companyName;
  final DateTime date;
  final String imageUrl;
  final String timeSlot;
  final String message;
  final bool isUrgent;

  const RunInAppointment({
    @required this.id,
    @required this.visitorName,
    @required this.employeeId,
    @required this.visitorEmail,
    @required this.visitorPhone,
    @required this.companyName,
    @required this.date,
    @required this.imageUrl,
    @required this.timeSlot,
    @required this.message,
    @required this.isUrgent,
  });
}
