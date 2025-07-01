import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final parts = appointment.patientName.split(' - ');
    final hospital = parts.isNotEmpty ? parts[0] : '-';
    final doctor = parts.length > 1 ? parts[1] : '-';

    final formattedDate =
        '${appointment.dateTime.year}-${appointment.dateTime.month.toString().padLeft(2, '0')}-${appointment.dateTime.day.toString().padLeft(2, '0')}';
    final formattedTime =
        '${appointment.dateTime.hour.toString().padLeft(2, '0')}:${appointment.dateTime.minute.toString().padLeft(2, '0')}';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: const Color(0xFFD1F6D3),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.local_hospital, size: 32, color: Colors.teal),
        title: Text(
          hospital,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dr. $doctor'),
              const SizedBox(height: 4),
              Text('$formattedDate • $formattedTime'),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black54),
        onTap: () {
          // TODO: Tambahkan navigasi detail jika perlu
        },
      ),
    );
  }
}
