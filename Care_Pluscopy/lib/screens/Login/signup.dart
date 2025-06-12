import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController existingConditionsController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController medicationsController = TextEditingController();
  final TextEditingController seniorIdController = TextEditingController();
  final TextEditingController customRelationshipController = TextEditingController();

  String? selectedRole;
  String? selectedRelationship;
  String? selectedCondition;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> roles = ['Senior', 'Guardian'];
  final List<String> relationships = ['Spouse', 'Child', 'Sibling', 'Friend', 'Caregiver', 'Other'];
  final List<String> conditions = [
    'Diabetes', 'Hypertension', 'Arthritis', 'Heart Disease', 'Dementia', 'Parkinson\'s',
    'Stroke', 'Asthma', 'Osteoporosis', 'Cancer', 'Other'
  ];

  void handleSignUp() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign-up successful!")));
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseFontSize = MediaQuery.of(context).size.width < 400 ? 16 : 18;

    InputDecoration _decoration(String label, IconData icon) {
      return InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 28),
        labelStyle: TextStyle(fontSize: baseFontSize),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      );
    }

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("CARE PLUS REGISTER", style: TextStyle(fontSize: baseFontSize + 4)),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: roles.map((role) {
                    return DropdownMenuItem(value: role, child: Text(role, style: TextStyle(fontSize: baseFontSize)));
                  }).toList(),
                  onChanged: (value) => setState(() => selectedRole = value),
                  decoration: _decoration("Select Role", Icons.person),
                  validator: (value) => value == null ? 'Please select a role' : null,
                ),
                SizedBox(height: 15),

                _buildTextField(nameController, "Full Name", Icons.person_outline, baseFontSize),
                _buildTextField(emailController, "Email", Icons.email_outlined, baseFontSize,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value != null && value.contains('@') ? null : 'Enter a valid email'),

                _buildPasswordField(passwordController, "Password", Icons.lock_outline, baseFontSize, _obscurePassword, () {
                  setState(() => _obscurePassword = !_obscurePassword);
                }),
                _buildPasswordField(confirmPasswordController, "Confirm Password", Icons.lock_outline, baseFontSize,
                    _obscureConfirmPassword, () {
                      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                    }, validator: (value) => value == passwordController.text ? null : 'Passwords do not match'),

                _buildTextField(contactNumberController, "Contact Number", Icons.phone, baseFontSize,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Contact number is required';
                      if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) return 'Enter valid number';
                      return null;
                    }),

                if (selectedRole == "Guardian") ..._buildGuardianFields(baseFontSize),
                if (selectedRole == "Senior") ..._buildSeniorFields(baseFontSize),

                SizedBox(height: 30),

                InkWell(
                  onTap: handleSignUp,
                  borderRadius: BorderRadius.circular(12),
                  splashColor: Colors.white,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_add, color: Colors.white),
                        SizedBox(width: 10),
                        Text("Register", style: TextStyle(color: Colors.white, fontSize: baseFontSize + 2)),
                      ],
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: Text("Already have an account? Login", style: TextStyle(fontSize: baseFontSize)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, double fontSize,
      {TextInputType? keyboardType, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 28),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          labelStyle: TextStyle(fontSize: fontSize),
        ),
        style: TextStyle(fontSize: fontSize),
        keyboardType: keyboardType,
        validator: validator ?? (value) => value == null || value.isEmpty ? '$label is required' : null,
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, IconData icon, double fontSize,
      bool obscure, VoidCallback toggle, {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 28),
          suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility), onPressed: toggle),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          labelStyle: TextStyle(fontSize: fontSize),
        ),
        style: TextStyle(fontSize: fontSize),
        validator: validator ?? (value) => value == null || value.length < 6 ? 'Min 6 characters' : null,
      ),
    );
  }

  List<Widget> _buildGuardianFields(double fontSize) {
    return [
      SizedBox(height: 15),
      _buildTextField(seniorIdController, "Senior ID", Icons.qr_code, fontSize),
      DropdownButtonFormField<String>(
        value: selectedRelationship,
        items: relationships.map((relation) {
          return DropdownMenuItem(value: relation, child: Text(relation, style: TextStyle(fontSize: fontSize)));
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedRelationship = value;
            if (selectedRelationship == "Other") {
              customRelationshipController.text = '';
            }
          });
        },
        decoration: InputDecoration(
          labelText: "Select Relationship",
          prefixIcon: Icon(Icons.link),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value == null ? 'Please select a relationship' : null,
      ),
      if (selectedRelationship == "Other")
        _buildTextField(customRelationshipController, "Custom Relationship", Icons.text_fields, fontSize),
    ];
  }

  List<Widget> _buildSeniorFields(double fontSize) {
    return [
      SizedBox(height: 20),
      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Medical History", style: TextStyle(fontSize: fontSize + 2, fontWeight: FontWeight.bold, color: Colors.green[800])),
              Divider(),
              DropdownButtonFormField<String>(
                value: selectedCondition,
                items: conditions.map((condition) {
                  return DropdownMenuItem(value: condition, child: Text(condition, style: TextStyle(fontSize: fontSize)));
                }).toList(),
                onChanged: (value) => setState(() => selectedCondition = value),
                decoration: InputDecoration(
                  labelText: "Select Existing Condition",
                  prefixIcon: Icon(Icons.medical_services),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null ? 'Please select a condition' : null,
              ),
              if (selectedCondition == 'Other')
                _buildTextField(existingConditionsController, "Other Condition", Icons.text_fields, fontSize),
              _buildTextField(allergiesController, "Allergies", Icons.warning, fontSize),
              _buildTextField(medicationsController, "Medications", Icons.medical_services, fontSize),
            ],
          ),
        ),
      )
    ];
  }
}
