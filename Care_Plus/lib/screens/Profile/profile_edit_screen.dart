import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

// 这里假设你有一个 ProfileTextBox 组件，如果没有，可以直接用 TextFormField 替代
//import 'ProfileTextBox.dart';

class ProfileEditScreen extends StatefulWidget {
  final bool isGuardian;

  const ProfileEditScreen({Key? key, this.isGuardian = false}) : super(key: key);

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
      text: "Jane Doe (+60198765432)");
  final _medicalController = TextEditingController(
      text: "Diabetes, Hypertension");
  final _allergyController = TextEditingController();

  DateTime? _selectedDOB;
  String? _selectedInsurance;

  File? _avatarImageFile;
  final ImagePicker _picker = ImagePicker();

  final List<String> _insuranceOptions = [
    'AIA',
    'Great Eastern',
    'Prudential',
    'Etiqa',
    'AXA',
    'Others',
  ];

  bool _showEditIcon = false;

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
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
    );

    if (pickedFile != null) {
      setState(() {
        _avatarImageFile = File(pickedFile.path);
      });
    }
  }

  void _pickDOB() async {
    DateTime initialDate = _selectedDOB ?? DateTime(1950);
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        // 绿色主题
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF4CAF50), // header background
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black87, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4CAF50), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDOB = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
        _ageController.text = _calculateAge(picked).toString();
      });
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Profile updated successfully."),
        backgroundColor: Color(0xFF4CAF50),
      ));
      Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 20,
        color: Color(0xFF4CAF50),
        fontWeight: FontWeight.w600,
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF4CAF50), width: 2),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal.shade300, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGuardian = widget.isGuardian;

    // 响应式字体大小适配
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final bool isSmallScreen = screenWidth < 360;
    final double labelFontSize = isSmallScreen ? 18 : 20;
    final double inputFontSize = isSmallScreen ? 18 : 20;

    return Scaffold(
      backgroundColor: const Color(0xFFF1FDF4),
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, size: 28),
            tooltip: 'Save',
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
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
                          backgroundImage: _avatarImageFile != null
                              ? FileImage(_avatarImageFile!)
                              : const AssetImage(
                              'assets/images/profile_avatar.png') as ImageProvider,
                        ),
                        AnimatedOpacity(
                          opacity: _showEditIcon ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.shade700.withOpacity(0.6),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildCard(
                child: TextFormField(
                  controller: _nameController,
                  validator: (val) =>
                  val == null || val.isEmpty
                      ? "Name required"
                      : null,
                  style: TextStyle(
                      fontSize: inputFontSize, fontWeight: FontWeight.w600),
                  decoration: _inputDecoration("Name"),
                ),
              ),

              _buildCard(
                child: TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _pickDOB,
                  validator: (val) =>
                  val == null || val.isEmpty
                      ? 'Date of birth required'
                      : null,
                  style: TextStyle(fontSize: inputFontSize),
                  decoration: _inputDecoration('Date of Birth').copyWith(
                    suffixIcon: const Icon(
                        Icons.calendar_today, color: Color(0xFF4CAF50)),
                  ),
                ),
              ),
              _buildCard(
                child: TextFormField(
                  controller: _ageController,
                  readOnly: true,
                  style: TextStyle(fontSize: inputFontSize),
                  decoration: _inputDecoration('Age'),
                ),
              ),

              _buildCard(
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) =>
                  val == null || !val.contains('@')
                      ? "Enter a valid email"
                      : null,
                  style: TextStyle(fontSize: inputFontSize),
                  decoration: _inputDecoration("Email"),
                ),
              ),

              _buildCard(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (val) =>
                  val == null || val.length < 10
                      ? "Invalid phone number"
                      : null,
                  style: TextStyle(fontSize: inputFontSize),
                  decoration: _inputDecoration("Phone"),
                ),
              ),

              if (!isGuardian)
                _buildCard(
                  child: TextFormField(
                    controller: _icController,
                    readOnly: true,
                    style: TextStyle(fontSize: inputFontSize),
                    decoration: _inputDecoration("IC/Passport Number"),
                  ),
                ),

              _buildCard(
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Insurance Plan',
                          labelStyle: TextStyle(fontSize: labelFontSize,
                              color: const Color(0xFF4CAF50),
                              fontWeight: FontWeight.w600),
                          border: InputBorder.none,
                        ),
                        value: _selectedInsurance,
                        items: _insuranceOptions
                            .map((ins) =>
                            DropdownMenuItem(
                              value: ins,
                              child: Text(ins,
                                  style: TextStyle(fontSize: inputFontSize)),
                            ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedInsurance = val;
                            if (val != 'Others') {
                              _otherInsuranceController.clear();
                            }
                          });
                        },
                        validator: (val) =>
                        val == null || val.isEmpty
                            ? 'Please select insurance'
                            : null,
                      ),
                    ),
                    if (_selectedInsurance == 'Others')
                      const SizedBox(width: 12),
                    if (_selectedInsurance == 'Others')
                      Expanded(
                        child: TextFormField(
                          controller: _otherInsuranceController,
                          validator: (val) {
                            if (_selectedInsurance == 'Others' &&
                                (val == null || val.isEmpty)) {
                              return 'Please specify insurance';
                            }
                            return null;
                          },
                          style: TextStyle(fontSize: inputFontSize),
                          decoration: _inputDecoration('Specify Insurance'),
                        ),
                      ),
                  ],
                ),
              ),

              _buildCard(
                child: TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Height required';
                    final h = double.tryParse(val);
                    if (h == null || h <= 0) return 'Enter valid height';
                    return null;
                  },
                  style: TextStyle(fontSize: inputFontSize),
                  decoration: _inputDecoration("Height (cm)"),
                ),
              ),

              _buildCard(
                child: TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Weight required';
                    final w = double.tryParse(val);
                    if (w == null || w <= 0) return 'Enter valid weight';
                    return null;
                  },
                  style: TextStyle(fontSize: inputFontSize),
                  decoration: _inputDecoration("Weight (kg)"),
                ),
              ),

              _buildCard(
                child: TextFormField(
                  controller: _familyDoctorController,
                  style: TextStyle(fontSize: inputFontSize),
                  decoration: _inputDecoration("Family Doctor"),
                ),
              ),

              _buildCard(
                child: TextFormField(
                  controller: _emergencyContactController,
                  style: TextStyle(fontSize: inputFontSize),
                  decoration: _inputDecoration("Emergency Contact"),
                ),
              ),

              if (!isGuardian)
                _buildCard(
                  child: TextFormField(
                    controller: _medicalController,
                    maxLines: 3,
                    style: TextStyle(fontSize: inputFontSize),
                    decoration: _inputDecoration("Medical History"),
                  ),
                ),

              _buildCard(
                child: TextFormField(
                  controller: _allergyController,
                  maxLines: 3,
                  style: TextStyle(fontSize: inputFontSize),
                  decoration: _inputDecoration("Allergy History"),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, size: 28),
                  label: Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    shadowColor: Colors.teal.shade700,
                    elevation: 6,
                    animationDuration: const Duration(milliseconds: 250),
                  ),
                  onPressed: _save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}