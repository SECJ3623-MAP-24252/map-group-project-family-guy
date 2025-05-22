import 'package:flutter/material.dart';

class ManageMedicineSchedule extends StatefulWidget {
  const ManageMedicineSchedule({super.key});

  @override
  State<ManageMedicineSchedule> createState() => _ManageMedicineScheduleState();
}

class _ManageMedicineScheduleState extends State<ManageMedicineSchedule> {
  final List<Map<String, String>> _medications = [];
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  TimeOfDay? _selectedTime;

  void _pickTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addMedication() {
    if (_formKey.currentState!.validate() && _selectedTime != null) {
      setState(() {
        _medications.add({
          'name': _nameController.text,
          'dose': _doseController.text,
          'time': _selectedTime!.format(context),
        });
        _nameController.clear();
        _doseController.clear();
        _selectedTime = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all fields and select time.'),
      ));
    }
  }

  void _removeMedication(int index) {
    setState(() {
      _medications.removeAt(index);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.teal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Medicine Schedule'),
        backgroundColor: themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form Input
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Medicine Name'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter medicine name' : null,
                  ),
                  TextFormField(
                    controller: _doseController,
                    decoration: const InputDecoration(labelText: 'Dosage'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter dosage' : null,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickTime(context),
                        icon: const Icon(Icons.access_time),
                        label: const Text("Select Time"),
                        style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _selectedTime == null
                            ? "No time selected"
                            : _selectedTime!.format(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addMedication,
                    style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                    child: const Text('Add Schedule'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Scheduled Medications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _medications.isEmpty
                  ? const Center(child: Text("No medication added yet."))
                  : ListView.builder(
                      itemCount: _medications.length,
                      itemBuilder: (context, index) {
                        final med = _medications[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.medication_outlined),
                            title: Text(med['name'] ?? ''),
                            subtitle: Text("Dose: ${med['dose']}, Time: ${med['time']}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeMedication(index),
                            ),
                          ),
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
