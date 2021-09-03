import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String imageUrl;
  final DateTime dateOfBirth;
  Employee({
    this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.username,
    @required this.email,
    @required this.dateOfBirth,
    @required this.imageUrl,
  });
}
