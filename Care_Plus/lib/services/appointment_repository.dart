// lib/services/appointment_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/appointment_model.dart';

class AppointmentRepository {
  final _col = FirebaseFirestore.instance.collection('appointments');

  /// 实时监听所有 appointment
  Stream<List<Appointment>> watchAll() {
    return _col
        .orderBy('dateTime')
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Appointment.fromMap(d.id, d.data()))
            .toList());
  }

  Future<List<Appointment>> fetchAll() async {
    final snap = await _col.orderBy('dateTime').get();
    return snap.docs
        .map((d) => Appointment.fromMap(d.id, d.data()))
        .toList();
  }

  Future<void> add(Appointment appt) => _col.add(appt.toMap());

  Future<void> update(Appointment appt) =>
      _col.doc(appt.id).update(appt.toMap());

  Future<void> delete(String id) => _col.doc(id).delete();
}
