import 'package:flutter/material.dart';
import 'signup.dart';
import 'login.dart'; // 导入 LoginScreen
import 'homepage.dart'; // 导入 MainScreen

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
      initialRoute: '/login', // 启动时跳转到登录页面
      routes: {
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(), // 确保 LoginScreen 作为 Widget 使用
        '/main': (context) => MainScreen(),
      },
    );
  }
}
