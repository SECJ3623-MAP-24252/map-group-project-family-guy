import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Care_Plus/widgets/profile_text_box.dart';

class ProfileEditScreen extends StatefulWidget {
  final bool isGuardian;
  const ProfileEditScreen({Key? key, this.isGuardian = false})
    : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: "John Doe");
  final _dobController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController(text: "john.doe@example.com");
  final _phoneController = TextEditingController(text: "+60123456789");
  final _icController = TextEditingController(text: "A1234567");
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _otherInsuranceController = TextEditingController();
  final _familyDoctorController = TextEditingController(text: "Dr. Smith");
  final _emergencyContactController = TextEditingController(
    text: "Jane Doe (+60198765432)",
  );
  final _medicalController = TextEditingController(
    text: "Diabetes, Hypertension",
  );
  final _allergyController = TextEditingController();

  DateTime? _selectedDOB;
  String? _selectedInsurance;

  File? _avatarFile;
  ImageProvider? _avatarImageProvider;
  String? _avatarBase64;
  final _picker = ImagePicker();
  final List<String> _insuranceOptions = [
    'AIA',
    'Great Eastern',
    'Prudential',
    'Etiqa',
    'AXA',
    'Others',
  ];
  bool _showEditIcon = false;

  final _docRef = FirebaseFirestore.instance
      .collection('profiles_demo')
      .doc('currentProfile');

  @override
  void initState() {
    super.initState();
    _docRef.get().then((snap) {
      if (snap.exists) {
        final data = snap.data()!;
        setState(() {
          _nameController.text = data['name'] ?? _nameController.text;
          _dobController.text = data['dob'] ?? _dobController.text;
          _ageController.text = data['age']?.toString() ?? _ageController.text;
          _emailController.text = data['email'] ?? _emailController.text;
          _phoneController.text = data['phone'] ?? _phoneController.text;
          _icController.text = data['icPassport'] ?? _icController.text;
          _heightController.text =
              data['height']?.toString() ?? _heightController.text;
          _weightController.text =
              data['weight']?.toString() ?? _weightController.text;
          _selectedInsurance = data['insurancePlan'] ?? _selectedInsurance;
          _otherInsuranceController.text =
              data['otherInsurance'] ?? _otherInsuranceController.text;
          _familyDoctorController.text =
              data['familyDoctor'] ?? _familyDoctorController.text;
          _emergencyContactController.text =
              data['emergencyContact'] ?? _emergencyContactController.text;
          _medicalController.text =
              data['medicalHistory'] ?? _medicalController.text;
          _allergyController.text =
              data['allergyHistory'] ?? _allergyController.text;
          _avatarBase64 = data['avatarBase64'] ?? _avatarBase64;
          if (_avatarBase64 != null && _avatarBase64!.isNotEmpty) {
            final bytes = base64Decode(_avatarBase64!);
            _avatarImageProvider = MemoryImage(bytes);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _icController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _otherInsuranceController.dispose();
    _familyDoctorController.dispose();
    _emergencyContactController.dispose();
    _medicalController.dispose();
    _allergyController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
    );
    if (picked != null) {
      final file = File(picked.path);
      final bytes = await file.readAsBytes();
      final b64 = base64Encode(bytes);
      setState(() {
        _avatarFile = file;
        _avatarBase64 = b64;
        _avatarImageProvider = MemoryImage(bytes);
      });
      await _docRef.set({'avatarBase64': b64}, SetOptions(merge: true));
    }
  }

  void _pickDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDOB ?? DateTime(1950),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder:
          (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF4CAF50),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      setState(() {
        _selectedDOB = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
        _ageController.text = _calculateAge(picked).toString();
      });
    }
  }

  int _calculateAge(DateTime birth) {
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day))
      age--;
    return age;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'name': _nameController.text.trim(),
      'dob': _dobController.text.trim(),
      'age': int.tryParse(_ageController.text) ?? 0,
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'icPassport': _icController.text.trim(),
      'height': double.tryParse(_heightController.text) ?? 0.0,
      'weight': double.tryParse(_weightController.text) ?? 0.0,
      'insurancePlan': _selectedInsurance ?? '',
      'otherInsurance': _otherInsuranceController.text.trim(),
      'familyDoctor': _familyDoctorController.text.trim(),
      'emergencyContact': _emergencyContactController.text.trim(),
      'medicalHistory': _medicalController.text.trim(),
      'allergyHistory': _allergyController.text.trim(),
      'avatarBase64': _avatarBase64 ?? '',
    };
    await _docRef.set(data, SetOptions(merge: true));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated successfully"),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
    Navigator.pop(context);
  }

  Widget _avatarPicker() => Center(
    child: MouseRegion(
      onEnter: (_) => setState(() => _showEditIcon = true),
      onExit: (_) => setState(() => _showEditIcon = false),
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 56,
              backgroundColor: Colors.teal.shade100,
              backgroundImage:
                  _avatarImageProvider ??
                  (_avatarFile != null
                          ? FileImage(_avatarFile!)
                          : const AssetImage(
                            'assets/images/profile_avatar.png',
                          ))
                      as ImageProvider,
            ),
            AnimatedOpacity(
              opacity: _showEditIcon ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.edit, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildCard(Widget child) => Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(padding: const EdgeInsets.all(12), child: child),
  );

  @override
  Widget build(BuildContext context) {
    final isGuardian = widget.isGuardian;
    return Scaffold(
      backgroundColor: const Color(0xFFF1FDF2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1FDF2),
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.check))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            _avatarPicker(),
            const SizedBox(height: 24),
            _buildCard(
              ProfileTextBox(
                controller: _nameController,
                label: "Name",
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
            ),
            _buildCard(
              ProfileTextBox(
                controller: _dobController,
                label: "Date of Birth",
                readOnly: true,
                onTap: _pickDOB,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
            ),
            _buildCard(
              ProfileTextBox(
                controller: _ageController,
                label: "Age",
                readOnly: true,
              ),
            ),
            _buildCard(
              ProfileTextBox(
                controller: _emailController,
                label: "Email",
                validator: (v) => v!.contains('@') ? null : "Invalid email",
              ),
            ),
            _buildCard(
              ProfileTextBox(
                controller: _phoneController,
                label: "Phone",
                keyboardType: TextInputType.phone,
                validator: (v) => v!.length < 10 ? "Invalid number" : null,
              ),
            ),
            if (!isGuardian)
              _buildCard(
                ProfileTextBox(
                  controller: _icController,
                  label: "IC/Passport",
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
              ),
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Insurance Plan",
                    style: TextStyle(
                      color: Colors.green.shade600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedInsurance,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    items:
                        _insuranceOptions
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged:
                        (v) => setState(() {
                          _selectedInsurance = v;
                          if (v != 'Others') _otherInsuranceController.clear();
                        }),
                    validator: (v) => v == null ? "Select insurance" : null,
                  ),
                  if (_selectedInsurance == 'Others') ...[
                    const SizedBox(height: 12),
                    ProfileTextBox(
                      controller: _otherInsuranceController,
                      label: "Specify Insurance",
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),
                  ],
                ],
              ),
            ),
            _buildCard(
              ProfileTextBox(
                controller: _heightController,
                label: "Height (cm)",
                keyboardType: TextInputType.number,
                validator:
                    (v) => double.tryParse(v!) != null ? null : "Invalid",
              ),
            ),
            _buildCard(
              ProfileTextBox(
                controller: _weightController,
                label: "Weight (kg)",
                keyboardType: TextInputType.number,
                validator:
                    (v) => double.tryParse(v!) != null ? null : "Invalid",
              ),
            ),
            _buildCard(
              ProfileTextBox(
                controller: _familyDoctorController,
                label: "Family Doctor",
              ),
            ),
            _buildCard(
              ProfileTextBox(
                controller: _emergencyContactController,
                label: "Emergency Contact",
              ),
            ),
            if (!isGuardian)
              _buildCard(
                ProfileTextBox(
                  controller: _medicalController,
                  label: "Medical History",
                  maxLines: 3,
                ),
              ),
            _buildCard(
              ProfileTextBox(
                controller: _allergyController,
                label: "Allergy History",
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 134, 196, 136),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
