// lib/screens/appointment/appointment_list_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/appointment_viewmodel.dart';
import 'appointment_edit_page.dart';

class AppointmentListPage extends StatelessWidget {
  const AppointmentListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AppointmentViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body:
          vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: vm.appointments.length,
                itemBuilder: (_, i) {
                  final appt = vm.appointments[i];
                  // 拆分 Hospital – Doctor
                  final parts = appt.patientName.split(' - ');
                  final hospital = parts.isNotEmpty ? parts[0] : '';
                  final doctor = parts.length > 1 ? parts[1] : '';
                  return ListTile(
                    leading: const Icon(
                      Icons.local_hospital,
                      color: Colors.teal,
                    ),
                    title: Text(
                      hospital,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '$doctor\n${_formatDateTime(appt.dateTime)}',
                      style: const TextStyle(height: 1.4),
                    ),
                    isThreeLine: true,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AppointmentEditPage(appt: appt),
                          ),
                        ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => AppointmentEditPage(appt: appt),
                                ),
                              ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (_) => AlertDialog(
                                    title: const Text('Confirm Deletion'),
                                    content: Text(
                                      'Delete appointment at $hospital with $doctor?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                            );
                            if (confirm == true) {
                              await vm.deleteAppointment(appt.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Deleted successfully'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AppointmentEditPage()),
            ),
        child: const Icon(Icons.add),
        tooltip: 'Add Appointment',
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} '
        '${two(dt.hour)}:${two(dt.minute)}';
  }
}
