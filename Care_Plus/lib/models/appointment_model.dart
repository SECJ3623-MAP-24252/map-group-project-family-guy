import 'package:flutter/material.dart';

class Appointment {
  final String patientName;
  final String hospitalName;
  final String doctorName;
  final DateTime dateTime;
  final IconData icon;
  final String location;
  final String note;

  Appointment({
    required this.patientName,
    required this.hospitalName,
    required this.doctorName,
    required this.dateTime,
    required this.icon,
    required this.location,
    required this.note,
  });
}
