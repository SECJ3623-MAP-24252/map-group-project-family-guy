import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital Appointment Scheduler',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const AppointmentPage(),
    );
  }
}

/// Data model for an appointment
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

/// Main page showing list of appointments
class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final List<Appointment> _appointments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 245, 216),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('My Appointments'),
        foregroundColor: const Color.fromARGB(255, 234, 250, 234),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert_outlined),
            tooltip: 'Add Appointment',
            onPressed: () async {
              final newAppt = await Navigator.push<Appointment>(
                context,
                MaterialPageRoute(builder: (_) => const AddAppointmentPage()),
              );
              if (newAppt != null) {
                setState(() {
                  _appointments.add(newAppt);
                });
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
            const Text(
              "Upcoming Appointments",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _appointments.isEmpty
                      ? const Center(child: Text("No appointments yet."))
                      : ListView.builder(
                        itemCount: _appointments.length,
                        itemBuilder: (context, index) {
                          final appt = _appointments[index];
                          final dateStr = DateFormat(
                            'EEEE, d MMMM',
                          ).format(appt.dateTime);
                          final timeStr = DateFormat(
                            'h:mm a',
                          ).format(appt.dateTime);
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

/// Widget for individual appointment cards
class AppointmentCard extends StatelessWidget {
  final String patientName;
  final String hospitalName;
  final String doctorName;
  final String date;
  final String time;
  final IconData icon;
  final String location;
  final String note;

  const AppointmentCard({
    Key? key,
    required this.patientName,
    required this.hospitalName,
    required this.doctorName,
    required this.date,
    required this.time,
    required this.icon,
    required this.location,
    required this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: const Color(0xFFE7F9E7),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(icon, size: 36, color: Colors.green[800]),
              title: Text(
                '$patientName with $doctorName at $hospitalName',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text("$date • $time"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location: $location",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Note: $note",
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Page for adding a new appointment with hospital-doctor selection
class AddAppointmentPage extends StatefulWidget {
  const AddAppointmentPage({super.key});

  @override
  _AddAppointmentPageState createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _patientCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String? _selectedHospital;
  String? _selectedDoctor;
  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;

  // Map of hospitals to their doctors
  final Map<String, List<String>> _hospitalDoctors = {
    'Hospital Kuala Lumpur': [
      'Dr. Ahmad Faiz',
      'Dr. Siti Nor',
      'Dr. Rajesh Kumar',
      'Dr. Mei Ling',
      'Dr. John Tan',
      'Dr. Nurul Iman',
      'Dr. Li Wei',
      'Dr. Noraini',
      'Dr. David Chua',
      'Dr. Tan Wei Ming',
    ],
    'Hospital Selayang': [
      'Dr. Ahmad Farhan',
      'Dr. Aishah Binti',
      'Dr. Kumar Dev',
      'Dr. Chen Hui',
      'Dr. Jackson Lee',
      'Dr. Hidayah',
      'Dr. Wei Jian',
      'Dr. Faridah',
      'Dr. Michael Ong',
      'Dr. Tan Xin Yi',
    ],
    'Hospital Sungai Buloh': [
      'Dr. Syafiq',
      'Dr. Nur Sarah',
      'Dr. Arjun Singh',
      'Dr. Li Xiu',
      'Dr. Lee Chong',
      'Dr. Zara',
      'Dr. Wen Hao',
      'Dr. Nur Farah',
      'Dr. Dennis Yeo',
      'Dr. Chua Mei Xin',
    ],
    'Hospital Ampang': [
      'Dr. Rizal',
      'Dr. Hana',
      'Dr. Vijay Kumar',
      'Dr. Lin Mei',
      'Dr. Peter Lim',
      'Dr. Aina',
      'Dr. Han Lei',
      'Dr. Nabila',
      'Dr. Samuel Tan',
      'Dr. Chan Yee Ling',
    ],
    'Hospital Serdang': [
      'Dr. Hafiz',
      'Dr. Raihan',
      'Dr. Balaji',
      'Dr. Zhang Wei',
      'Dr. George Tan',
      'Dr. Nadia',
      'Dr. Jun Hao',
      'Dr. Farzana',
      'Dr. Kelvin Chong',
      'Dr. Lee Mei Lin',
    ],
    'Hospital Tengku Ampuan Rahimah': [
      'Dr. Amir',
      'Dr. Salmah',
      'Dr. Ramesh',
      'Dr. Xiu Ying',
      'Dr. Kelvin Lee',
      'Dr. Siti Aisyah',
      'Dr. Hao Yu',
      'Dr. Shalini',
      'Dr. Suresh',
      'Dr. Patricia Tan',
    ],
    'Hospital Sultanah Aminah': [
      'Dr. Azlan',
      'Dr. Faridah',
      'Dr. Raj',
      'Dr. Mei Mei',
      'Dr. Desmond Tan',
      'Dr. Nuriza',
      'Dr. Qi Ming',
      'Dr. Kavitha',
      'Dr. Rishi',
      'Dr. Susan Ooi',
    ],
    'Hospital Sultan Ismail': [
      'Dr. Faizal',
      'Dr. Syahirah',
      'Dr. Prakash',
      'Dr. Li Na',
      'Dr. Derek Lim',
      'Dr. Nuraina',
      'Dr. Zhi Wei',
      'Dr. Meera',
      'Dr. Hari',
      'Dr. Agnes Lee',
    ],
    'Gleneagles Hospital Penang': [
      'Dr. Lim Chee Wah',
      'Dr. Tan Li Ying',
      'Dr. Rajesh',
      'Dr. Chen Xiao',
      'Dr. Voon Wei',
      'Dr. Nurul Huda',
      'Dr. Jin Hao',
      'Dr. Kavya',
      'Dr. Anand',
      'Dr. Linda Lim',
    ],
    'Pantai Hospital Kuala Lumpur': [
      'Dr. Mohd Azrin',
      'Dr. Lee Siew Ling',
      'Dr. Rajan',
      'Dr. Lin Xia',
      'Dr. Michael Tan',
      'Dr. Nurul Shafiqah',
      'Dr. Wen Jie',
      'Dr. Shankar',
      'Dr. Sureswari',
      'Dr. Elaine Tan',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final doctors =
        _selectedHospital != null
            ? _hospitalDoctors[_selectedHospital]!
            : <String>[];

    return Scaffold(
      appBar: AppBar(title: const Text("Add Appointment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _patientCtrl,
                decoration: const InputDecoration(labelText: 'Patient Name'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Enter patient name' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Hospital'),
                items:
                    _hospitalDoctors.keys
                        .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                        .toList(),
                value: _selectedHospital,
                onChanged: (val) {
                  setState(() {
                    _selectedHospital = val;
                    _selectedDoctor = null;
                  });
                },
                validator: (v) => v == null ? 'Please select a hospital' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Doctor'),
                items:
                    doctors
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                value: _selectedDoctor,
                onChanged: (val) => setState(() => _selectedDoctor = val),
                validator: (v) => v == null ? 'Please select a doctor' : null,
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(
                  _pickedDate == null
                      ? 'Choose Date'
                      : DateFormat('yMMMMd').format(_pickedDate!),
                ),
                leading: const Icon(Icons.calendar_today),
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (d != null) setState(() => _pickedDate = d);
                },
              ),
              ListTile(
                title: Text(
                  _pickedTime == null
                      ? 'Choose Time'
                      : _pickedTime!.format(context),
                ),
                leading: const Icon(Icons.access_time),
                onTap: () async {
                  final t = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (t != null) setState(() => _pickedTime = t);
                },
              ),
              TextFormField(
                controller: _locationCtrl,
                decoration: const InputDecoration(labelText: 'Location'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Enter location' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(labelText: 'Note'),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _pickedDate != null &&
                      _pickedTime != null) {
                    final dt = DateTime(
                      _pickedDate!.year,
                      _pickedDate!.month,
                      _pickedDate!.day,
                      _pickedTime!.hour,
                      _pickedTime!.minute,
                    );
                    final newAppt = Appointment(
                      patientName: _patientCtrl.text,
                      hospitalName: _selectedHospital!,
                      doctorName: _selectedDoctor!,
                      dateTime: dt,
                      icon: Icons.local_hospital,
                      location: _locationCtrl.text,
                      note: _noteCtrl.text,
                    );
                    Navigator.pop(context, newAppt);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please complete all required fields'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _patientCtrl.dispose();
    _locationCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }
}
