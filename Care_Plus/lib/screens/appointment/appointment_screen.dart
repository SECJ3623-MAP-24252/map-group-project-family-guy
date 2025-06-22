import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Care_Plus/models/appointment_model.dart';
import 'package:Care_Plus/screens/appointment/add_appointment_screen.dart';
import 'package:Care_Plus/widgets/appointment_card.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final List<Appointment> _appointments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 245, 216),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('My Appointments'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert_outlined),
            tooltip: 'Add Appointment',
            onPressed: () async {
              final newAppt = await Navigator.push<Appointment>(
                context,
                MaterialPageRoute(builder: (_) => const AddAppointmentScreen()),
              );
              if (newAppt != null) {
                setState(() => _appointments.add(newAppt));
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Upcoming Appointments",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: _appointments.isEmpty
                  ? const Center(child: Text("No appointments yet."))
                  : ListView.builder(
                      itemCount: _appointments.length,
                      itemBuilder: (context, index) {
                        final appt = _appointments[index];
                        final dateStr = DateFormat('EEEE, d MMMM').format(appt.dateTime);
                        final timeStr = DateFormat('h:mm a').format(appt.dateTime);
                        return AppointmentCard(
                          patientName: appt.patientName,
                          hospitalName: appt.hospitalName,
                          doctorName: appt.doctorName,
                          date: dateStr,
                          time: timeStr,
                          icon: appt.icon,
                          location: appt.location,
                          note: appt.note,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
