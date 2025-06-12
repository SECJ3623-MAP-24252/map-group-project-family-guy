import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 验证邮箱格式
  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  // 显示提示框
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title, style: TextStyle(fontSize: 22)),
            content: Text(message, style: TextStyle(fontSize: 20)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK", style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
    );
  }

  // 密码重置弹窗
  void _showResetPasswordDialog() {
    TextEditingController resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Reset Password", style: TextStyle(fontSize: 22)),
            content: TextFormField(
              controller: resetEmailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                labelText: "Enter your email",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(fontSize: 18)),
              ),
              ElevatedButton(
                onPressed: () {
                  String email = resetEmailController.text.trim();
                  if (_isValidEmail(email)) {
                    Navigator.pop(context);
                    _showDialog(
                      "Success",
                      "Password reset link sent to $email.",
                    );
                  } else {
                    _showDialog("Error", "Please enter a valid email address.");
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  // 登录逻辑（含延迟）
  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text;

    if (!_isValidEmail(email)) {
      _showDialog("Error", "Please enter a valid email address.");
    } else if (password.length < 4) {
      _showDialog("Error", "Password must be at least 4 characters long.");
    } else {
      if (email == "123456@123.com" && password == "123456") {
        _showDialog("Success", "Login successful.");
        await Future.delayed(Duration(seconds: 0));
        Navigator.pushReplacementNamed(context, '/loading');
      } else {
        _showDialog("Error", "Invalid email or password.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/images/profile_avatar.png',
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Welcome Back!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 26 : 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        SizedBox(height: 40),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(fontSize: 18),
                            prefixIcon: Icon(Icons.email, color: Colors.green),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(fontSize: 18),
                            prefixIcon: Icon(Icons.lock, color: Colors.green),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 30),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 5,
                              shadowColor: Colors.greenAccent,
                            ),
                            onPressed: _login,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: _showResetPasswordDialog,
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed:
                              () => Navigator.pushReplacementNamed(
                                context,
                                '/signup',
                              ),
                          child: Text(
                            "Don't have an account? Register",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
