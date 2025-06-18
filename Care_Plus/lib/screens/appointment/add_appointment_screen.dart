import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Care_Plus/models/appointment_model.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String? _selectedHospital;
  String? _selectedDoctor;
  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;

  final Map<String, List<String>> _hospitalDoctors = {
    'Hospital Kuala Lumpur': ['Dr. Ahmad Faiz', 'Dr. Siti Nor', 'Dr. Rajesh Kumar'],
    'Hospital Selayang': ['Dr. Ahmad Farhan', 'Dr. Aishah Binti'],
    'Hospital Sungai Buloh': ['Dr. Syafiq', 'Dr. Nur Sarah'],
    'Pantai Hospital KL': ['Dr. Mohd Azrin', 'Dr. Lee Siew Ling'],
  };

  @override
  Widget build(BuildContext context) {
    final List<String> doctors = _selectedHospital != null ? _hospitalDoctors[_selectedHospital]! : <String>[];

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
                validator: (v) => v == null || v.isEmpty ? 'Enter patient name' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Hospital'),
                items: _hospitalDoctors.keys
                    .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                    .toList(),
                value: _selectedHospital,
                onChanged: (val) {
                  setState(() {
                    _selectedHospital = val;
                    _selectedDoctor = null;
                  });
                },
                validator: (v) => v == null ? 'Select hospital' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Doctor'),
                items: doctors
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                value: _selectedDoctor,
                onChanged: (val) => setState(() => _selectedDoctor = val),
                validator: (v) => v == null ? 'Select doctor' : null,
              ),
              ListTile(
                title: Text(_pickedDate == null
                    ? 'Choose Date'
                    : DateFormat('yMMMMd').format(_pickedDate!)),
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
                title: Text(_pickedTime == null
                    ? 'Choose Time'
                    : _pickedTime!.format(context)),
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
                validator: (v) => v == null || v.isEmpty ? 'Enter location' : null,
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
                      const SnackBar(content: Text('Please complete all required fields')),
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
