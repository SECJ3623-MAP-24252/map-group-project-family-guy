import 'package:flutter/material.dart';
import 'signup.dart';
import 'login.dart'; 
import 'homepage.dart'; 

void main() {
  runApp(HealthMonitorApp());
}

class HealthMonitorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Senior Health Monitor',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', 
      routes: {
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(), 
        '/main': (context) => MainScreen(),
      },
    );
  }
}
