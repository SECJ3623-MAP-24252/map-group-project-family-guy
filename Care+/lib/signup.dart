import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Email input
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter your email'
                            : null,
              ),
              SizedBox(height: 16),

              // Password input
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                keyboardType: TextInputType.text,
                validator:
                    (value) =>
                        value == null || value.length < 6
                            ? 'Min 6 characters'
                            : null,
              ),
              SizedBox(height: 16),

              // Role Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Select Role"),
                value: selectedRole,
                items:
                    ['guardian', 'senior'].map((role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role[0].toUpperCase() + role.substring(1)),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
                validator:
                    (value) => value == null ? 'Please select a role' : null,
              ),
              SizedBox(height: 24),

              // Sign Up button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Email: ${emailController.text}");
                    print("Password: ${passwordController.text}");
                    print("Role: $selectedRole");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Signed up successfully")),
                    );

                    // Navigate to login screen after successful sign-up
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pushReplacementNamed(context, '/login');
                    });
                  }
                },
                child: Text("Sign Up"),
              ),
              SizedBox(height: 16),

              // Sign Up with Phone (Button Style)
              ElevatedButton.icon(
                onPressed: () {
                  showPhoneSignUpDialog(context);
                },
                icon: Icon(Icons.phone),
                label: Text("Sign Up with Phone Number"),
              ),

              // Google Sign In (Button Style)
              ElevatedButton.icon(
                onPressed: () {
                  // Simulate Google login success
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Google account signed in")),
                  );
                  print("Signed in with Google (mock)");
                },
                icon: Icon(Icons.account_circle),
                label: Text("Sign Up with Google"),
              ),

              // Back to login
              TextButton(
                onPressed: () {
                  // Navigate back to login
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text("Already have an account? Back to Login"),
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
