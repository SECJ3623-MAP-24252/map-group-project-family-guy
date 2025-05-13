import 'package:flutter/material.dart';
class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Sign Up with Email"),
              onPressed: () {
                // 这里你可以加入注册逻辑
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            ElevatedButton(
              child: Text("Sign Up with Phone Number"),
              onPressed: () {
                // 预留手机注册逻辑
              },
            ),
            ElevatedButton(
              child: Text("Sign Up with Google"),
              onPressed: () {
                // 预留Google注册逻辑
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
