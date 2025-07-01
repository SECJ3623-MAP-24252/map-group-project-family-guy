import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageMedicineScreen extends StatefulWidget {
  const ManageMedicineScreen({super.key});

  @override
  _ManageMedicineScreenState createState() => _ManageMedicineScreenState();
}

class _ManageMedicineScreenState extends State<ManageMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final List<TimeOfDay> _selectedTimes = [];
  final List<Map<String, dynamic>> _medications = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMedicationsFromFirestore(); // ✅ load data saat halaman dibuka
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _selectedTimes.add(picked);
      });
    }
  }

  Future<void> fetchMedicationsFromFirestore() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('medicines')
          .orderBy('createdAt', descending: true)
          .get();

      final List<Map<String, dynamic>> loadedMeds = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        loadedMeds.add({
          'docId': doc.id,
          'name': data['name'],
          'dose': data['dose'],
          'times': List<String>.from(data['times']),
        });
      }

      setState(() {
        _medications.clear();
        _medications.addAll(loadedMeds);
      });
    } catch (e) {
      debugPrint('Error fetching meds: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load medication data')),
      );
    }
  }

  Future<void> saveMedicationToFirestore(Map<String, dynamic> medicationData) async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('medicines')
          .add(medicationData);
      debugPrint('Saved to Firestore');

      setState(() {
        _medications.insert(0, {
          ...medicationData,
          'docId': docRef.id,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medication added successfully")),
      );
    } catch (e) {
      debugPrint('Failed to save to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save to Firestore')),
      );
    }
  }

  Future<void> _addMedication() async {
    if (_formKey.currentState!.validate() && _selectedTimes.isNotEmpty) {
      setState(() => _isLoading = true);

      final timeStrings = _selectedTimes.map((t) => t.format(context)).toList();

      final medicationData = {
        'name': _nameController.text,
        'dose': _doseController.text,
        'times': timeStrings,
        'createdAt': Timestamp.now(),
      };

      await saveMedicationToFirestore(medicationData);

      _nameController.clear();
      _doseController.clear();
      _selectedTimes.clear();

      setState(() => _isLoading = false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and add at least one time.')),
      );
    }
  }

  Future<void> _removeMedication(int index) async {
    final docId = _medications[index]['docId'];

    try {
      await FirebaseFirestore.instance
          .collection('medicines')
          .doc(docId)
          .delete();

      setState(() {
        _medications.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medication deleted")),
      );
    } catch (e) {
      debugPrint('Error deleting: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete from Firestore")),
      );
    }
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
        title: const Text('Medicine Reminder'),
        backgroundColor: themeColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Add Medication',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Medicine Name',
                          prefixIcon: Icon(Icons.medication),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Please enter medicine name' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _doseController,
                        decoration: const InputDecoration(
                          labelText: 'Dosage',
                          prefixIcon: Icon(Icons.format_list_numbered),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Please enter dosage' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _pickTime(context),
                            icon: const Icon(Icons.access_time),
                            label: const Text("Add Time"),
                            style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _selectedTimes.isEmpty
                                ? "No time added"
                                : "${_selectedTimes.length} time(s)",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _selectedTimes
                            .map((time) => Chip(
                                  label: Text(time.format(context)),
                                  deleteIcon: const Icon(Icons.close),
                                  onDeleted: () {
                                    setState(() {
                                      _selectedTimes.remove(time);
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _addMedication,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('Add Schedule', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.list_alt, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'Scheduled Medications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _medications.isEmpty
                ? const Center(child: Text("No medication added yet."))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _medications.length,
                    itemBuilder: (context, index) {
                      final data = _medications[index];
                      final List times = data['times'] ?? [];

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.medication_liquid, color: Colors.teal),
                          title: Text(data['name'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Dose: ${data['dose']}"),
                              Text("Times: ${times.join(', ')}"),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Confirm Deletion"),
                                  content: const Text(
                                      "Are you sure you want to delete this medication?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(true),
                                      child: const Text("Delete",
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await _removeMedication(index);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
