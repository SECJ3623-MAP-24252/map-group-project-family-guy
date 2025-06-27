// lib/viewmodels/appointment_viewmodel.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/appointment_model.dart';
import '../services/appointment_repository.dart';

class AppointmentViewModel extends ChangeNotifier {
  final AppointmentRepository _repo = AppointmentRepository();
  final FlutterLocalNotificationsPlugin _notifier;
  StreamSubscription<List<Appointment>>? _sub;

  List<Appointment> appointments = [];
  bool isLoading = true;

  AppointmentViewModel(this._notifier) {
    // 实时订阅
    _sub = _repo.watchAll().listen((list) {
      appointments = list;
      isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> addAppointment(Appointment appt) async {
    await _repo.add(appt);
    // 立刻与定时通知逻辑不变…
    await _notifier.show(
      appt.hashCode,
      'Appointment Created',
      'Scheduled ${appt.patientName} at ${_formatDateTime(appt.dateTime)}',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'appt_channel',
          'Appointment Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );

    final tzDate = tz.TZDateTime.from(appt.dateTime, tz.local);
    await _notifier.zonedSchedule(
      appt.hashCode,
      'Appointment Reminder',
      'Time for ${appt.patientName}',
      tzDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'appt_channel',
          'Appointment Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> updateAppointment(Appointment appt) async {
    await _repo.update(appt);
  }

  Future<void> deleteAppointment(String id) async {
    await _repo.delete(id);
  }

  String _formatDateTime(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} '
        '${two(dt.hour)}:${two(dt.minute)}';
  }
}
