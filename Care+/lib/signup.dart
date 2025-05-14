import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  // Senior
  final TextEditingController existingConditionsController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController medicationsController = TextEditingController();

  // Guardian
  final TextEditingController seniorIdController = TextEditingController();
  String? selectedRelationship;
  final TextEditingController customRelationshipController = TextEditingController();

  // Role
  String? selectedRole;
  final List<String> roles = ['Senior', 'Guardian'];
  final List<String> relationships = ['Spouse', 'Child', 'Sibling', 'Friend', 'Caregiver', 'Other'];
  final List<String> conditions = [
    'Diabetes', 'Hypertension', 'Arthritis', 'Heart Disease', 'Dementia', 'Parkinson\'s',
    'Stroke', 'Asthma', 'Osteoporosis', 'Cancer', 'Other'
  ];
  String? selectedCondition;

  final _formKey = GlobalKey<FormState>();

  void handleSignUp() {
    if (_formKey.currentState!.validate()) {
      // Perform sign-up logic (e.g. Firebase or backend integration)
      print("Sign-up successful!");
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register"), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Role selection
              DropdownButtonFormField<String>(
                value: selectedRole,
                hint: Text("Select Role"),
                items: roles.map((role) {
                  return DropdownMenuItem<String>(value: role, child: Text(role));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a role' : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 15),

              // Name, Email, Password fields
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value != null && value.contains('@') ? null : 'Enter a valid email',
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) => value != null && value.length >= 6 ? null : 'Minimum 6 characters required',
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) => value == passwordController.text ? null : 'Passwords do not match',
              ),
              SizedBox(height: 10),
              // Contact Number Field
              TextFormField(
                controller: contactNumberController,
                decoration: InputDecoration(
                  labelText: "Contact Number",
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Contact number is required';
                  } else if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),

              // Guardian Section
              if (selectedRole == "Guardian") ...[
                SizedBox(height: 20),
                TextFormField(
                  controller: seniorIdController,
                  decoration: InputDecoration(
                    labelText: "Senior ID",
                    prefixIcon: Icon(Icons.qr_code),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Senior ID is required' : null,
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: selectedRelationship,
                  hint: Text("Select Relationship"),
                  items: relationships.map((relation) {
                    return DropdownMenuItem<String>(value: relation, child: Text(relation));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRelationship = value;
                      // If "Other" is selected, show the manual input field
                      if (selectedRelationship == "Other") {
                        customRelationshipController.text = ''; // Clear the custom text if "Other" is selected
                      }
                    });
                  },
                  validator: (value) => value == null ? 'Please select a relationship' : null,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
                // If "Other" is selected, show a text field to input the custom relationship
                if (selectedRelationship == "Other") ...[
                  SizedBox(height: 15),
                  TextFormField(
                    controller: customRelationshipController,
                    decoration: InputDecoration(
                      labelText: "Enter Custom Relationship",
                      prefixIcon: Icon(Icons.text_fields),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a custom relationship' : null,
                  ),
                ],
              ],

              // Senior Section
              if (selectedRole == "Senior") ...[
                SizedBox(height: 20),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Medical History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        Divider(),
                        SizedBox(height: 10),

                        // Existing Conditions Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedCondition,
                          hint: Text("Select Existing Condition"),
                          items: conditions.map((condition) {
                            return DropdownMenuItem<String>(value: condition, child: Text(condition));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCondition = value;
                            });
                          },
                          validator: (value) => value == null ? 'Please select a condition' : null,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.medical_services),
                          ),
                        ),
                        if (selectedCondition == 'Other') ...[
                          SizedBox(height: 10),
                          TextFormField(
                            controller: existingConditionsController,
                            decoration: InputDecoration(
                              labelText: "Other Condition",
                              hintText: "Describe condition",
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                        SizedBox(height: 15),

                        // Allergies and Medications
                        TextFormField(
                          controller: allergiesController,
                          decoration: InputDecoration(
                            labelText: "Allergies",
                            hintText: "e.g., Penicillin, Nuts",
                            prefixIcon: Icon(Icons.warning),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: medicationsController,
                          decoration: InputDecoration(
                            labelText: "Medications",
                            hintText: "e.g., Metformin, Aspirin",
                            prefixIcon: Icon(Icons.medical_services),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(Icons.person_add),
                label: Text("Register"),
                onPressed: handleSignUp,
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showPhoneSignUpDialog(BuildContext context) {
    final phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Phone Sign Up"),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: "Enter your phone number"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String phone = phoneController.text.trim();
                if (phone.isNotEmpty &&
                    RegExp(r'^\+?\d{9,15}$').hasMatch(phone)) {
                  print("Phone: $phone");
                  print("Role: $selectedRole");
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Phone signed up successfully")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please enter a valid phone number"),
                    ),
                  );
                }
              },
              child: Text("Sign Up"),
            ),
          ],
        );
      },
    );
  }
}
