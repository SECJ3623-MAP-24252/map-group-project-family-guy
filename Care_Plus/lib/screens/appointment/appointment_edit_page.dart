import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/appointment_model.dart';
import '../../viewmodels/appointment_viewmodel.dart';

class AppointmentEditPage extends StatefulWidget {
  /// If `appt` is null, we're creating a new appointment; otherwise editing.
  final Appointment? appt;
  const AppointmentEditPage({Key? key, this.appt}) : super(key: key);

  @override
  _AppointmentEditPageState createState() => _AppointmentEditPageState();
}

class _AppointmentEditPageState extends State<AppointmentEditPage> {
  final _formKey = GlobalKey<FormState>();
  late String _hospital;
  late String _doctor;
  DateTime _dateTime = DateTime.now().add(const Duration(hours: 1));

  @override
  void initState() {
    super.initState();
    if (widget.appt != null) {
      // Split patientName into "Hospital - Doctor"
      final parts = widget.appt!.patientName.split(' - ');
      _hospital = parts.isNotEmpty ? parts[0] : '';
      _doctor = parts.length > 1 ? parts[1] : '';
      _dateTime = widget.appt!.dateTime;
    } else {
      _hospital = '';
      _doctor = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.appt != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Appointment' : 'New Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Hospital name input
              TextFormField(
                initialValue: _hospital,
                decoration: const InputDecoration(
                  labelText: 'Hospital Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_hospital),
                ),
                onSaved: (v) => _hospital = v!.trim(),
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Please enter hospital name'
                            : null,
              ),
              const SizedBox(height: 16),

              // Doctor name input
              TextFormField(
                initialValue: _doctor,
                decoration: const InputDecoration(
                  labelText: 'Doctor Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                onSaved: (v) => _doctor = v!.trim(),
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Please enter doctor name'
                            : null,
              ),
              const SizedBox(height: 16),

              // Date picker
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: Colors.grey.shade200,
                title: Text(
                  'Date: ${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 8),

              // Time picker
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: Colors.grey.shade200,
                title: Text(
                  'Time: ${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: _pickTime,
              ),

              const Spacer(),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSave,
                  child: Text(
                    isEditing ? 'Update Appointment' : 'Create Appointment',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          _dateTime.hour,
          _dateTime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _dateTime.hour, minute: _dateTime.minute),
    );
    if (t != null) {
      setState(() {
        _dateTime = DateTime(
          _dateTime.year,
          _dateTime.month,
          _dateTime.day,
          t.hour,
          t.minute,
        );
      });
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final fullName = '$_hospital - $_doctor';
    final appt = Appointment(
      id: widget.appt?.id,
      patientName: fullName,
      dateTime: _dateTime,
      note: '',
    );

    final vm = context.read<AppointmentViewModel>();
    if (widget.appt != null) {
      await vm.updateAppointment(appt);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Appointment updated')));
    } else {
      await vm.addAppointment(appt);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Appointment created')));
    }
    Navigator.pop(context);
  }
}
