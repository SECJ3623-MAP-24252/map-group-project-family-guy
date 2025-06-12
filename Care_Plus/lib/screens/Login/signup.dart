// lib/screens/Login/signup.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController existingConditionsController =
      TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController medicationsController = TextEditingController();
  final TextEditingController seniorIdController = TextEditingController();
  final TextEditingController customRelationshipController =
      TextEditingController();

  String? selectedRole;
  String? selectedRelationship;
  String? selectedCondition;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final List<String> roles = ['Senior', 'Guardian'];
  final List<String> relationships = [
    'Spouse',
    'Child',
    'Sibling',
    'Friend',
    'Caregiver',
    'Other',
  ];
  final List<String> conditions = [
    'Diabetes',
    'Hypertension',
    'Arthritis',
    'Heart Disease',
    'Dementia',
    'Parkinson\'s',
    'Stroke',
    'Asthma',
    'Osteoporosis',
    'Cancer',
    'Other',
  ];

  // 显示对话框
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title, style: const TextStyle(fontSize: 22)),
            content: Text(message, style: const TextStyle(fontSize: 20)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
    );
  }

  // 注册并写入 Firestore
  Future<void> handleSignUp() async {
    if (!_formKey.currentState!.validate() || selectedRole == null) {
      _showDialog("Error", "请完整填写所有必填项");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showDialog("Error", "两次输入的密码不一致");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. 创建 Firebase Auth 用户
      UserCredential userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
          );

      String uid = userCred.user!.uid;

      // 2. 将用户信息写入 Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'role': selectedRole,
        'contactNumber': contactNumberController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        // Guardian 专属
        if (selectedRole == 'Guardian') ...{
          'seniorId': seniorIdController.text.trim(),
          'relationship':
              selectedRelationship == 'Other'
                  ? customRelationshipController.text.trim()
                  : selectedRelationship,
        },
        // Senior 专属
        if (selectedRole == 'Senior') ...{
          'existingCondition':
              selectedCondition == 'Other'
                  ? existingConditionsController.text.trim()
                  : selectedCondition,
          'allergies': allergiesController.text.trim(),
          'medications': medicationsController.text.trim(),
        },
      });

      // 注册成功，跳转登录
      if (!mounted) return;
      _showDialog("Success", "注册成功，请登录");
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      _showDialog("注册失败", e.message ?? "未知错误");
    } finally {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(
          "CARE PLUS REGISTER",
          style: TextStyle(fontSize: baseFontSize + 4),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 角色选择
              DropdownButtonFormField<String>(
                value: selectedRole,
                items:
                    roles
                        .map(
                          (r) => DropdownMenuItem(
                            value: r,
                            child: Text(
                              r,
                              style: TextStyle(fontSize: baseFontSize),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (v) => setState(() => selectedRole = v),
                decoration: _decoration("Select Role", Icons.person),
                validator: (v) => v == null ? '请选择角色' : null,
              ),
              const SizedBox(height: 15),

              // 通用字段
              TextFormField(
                controller: nameController,
                decoration: _decoration("Full Name", Icons.person_outline),
                validator: (v) => v == null || v.isEmpty ? '请输入姓名' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _decoration("Email", Icons.email_outlined),
                validator:
                    (v) => v != null && v.contains('@') ? null : '请输入有效邮箱',
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: _decoration(
                  "Password",
                  Icons.lock_outline,
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed:
                        () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                  ),
                ),
                validator:
                    (v) => v != null && v.length >= 6 ? null : '密码最少 6 位',
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: _decoration(
                  "Confirm Password",
                  Icons.lock_outline,
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed:
                        () => setState(
                          () =>
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                        ),
                  ),
                ),
                validator:
                    (v) => v == passwordController.text ? null : '两次密码不一致',
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: contactNumberController,
                keyboardType: TextInputType.phone,
                decoration: _decoration("Contact Number", Icons.phone),
                validator: (v) {
                  if (v == null || v.isEmpty) return '请输入联系电话';
                  if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(v))
                    return '请输入有效号码';
                  return null;
                },
              ),

              // Guardian 专属
              if (selectedRole == "Guardian") ...[
                const SizedBox(height: 15),
                TextFormField(
                  controller: seniorIdController,
                  decoration: _decoration("Senior ID", Icons.qr_code),
                  validator:
                      (v) => v == null || v.isEmpty ? '请输入被监护人 ID' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedRelationship,
                  items:
                      relationships
                          .map(
                            (r) => DropdownMenuItem(
                              value: r,
                              child: Text(
                                r,
                                style: TextStyle(fontSize: baseFontSize),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (v) => setState(() {
                        selectedRelationship = v;
                        if (v != 'Other') customRelationshipController.clear();
                      }),
                  decoration: _decoration("Select Relationship", Icons.link),
                  validator: (v) => v == null ? '请选择关系' : null,
                ),
                if (selectedRelationship == "Other")
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: customRelationshipController,
                      decoration: _decoration(
                        "Custom Relationship",
                        Icons.text_fields,
                      ),
                      validator:
                          (v) => v == null || v.isEmpty ? '请输入自定义关系' : null,
                    ),
                  ),
              ],

              // Senior 专属
              if (selectedRole == "Senior") ...[
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: selectedCondition,
                  items:
                      conditions
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                c,
                                style: TextStyle(fontSize: baseFontSize),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => selectedCondition = v),
                  decoration: _decoration(
                    "Select Existing Condition",
                    Icons.medical_services,
                  ),
                  validator: (v) => v == null ? '请选择病史' : null,
                ),
                if (selectedCondition == "Other")
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: existingConditionsController,
                      decoration: _decoration(
                        "Other Condition",
                        Icons.text_fields,
                      ),
                      validator:
                          (v) => v == null || v.isEmpty ? '请输入病史详情' : null,
                    ),
                  ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: allergiesController,
                  decoration: _decoration("Allergies", Icons.warning),
                  validator: (v) => v == null ? '请输入过敏信息' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: medicationsController,
                  decoration: _decoration(
                    "Medications",
                    Icons.medical_services,
                  ),
                  validator: (v) => v == null ? '请输入用药信息' : null,
                ),
              ],

              const SizedBox(height: 30),

              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_add, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: baseFontSize + 2,
                          ),
                        ),
                      ],
                    ),
                  ),

              TextButton(
                onPressed:
                    () => Navigator.pushReplacementNamed(context, '/login'),
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(fontSize: baseFontSize),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
