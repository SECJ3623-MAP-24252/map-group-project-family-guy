// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:Care_Plus/screens/Loading/loading.dart';
import 'package:Care_Plus/screens/home/homepage.dart' as home_page;
import 'package:Care_Plus/screens/profile/profile_screen.dart' as profile_page;
import 'package:Care_Plus/screens/Login/signup.dart';
import 'package:Care_Plus/screens/Login/login.dart';
import 'package:Care_Plus/screens/profile/profile_edit_screen.dart';
import 'package:Care_Plus/screens/contact_relatives/contact_relatives_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ← 在 runApp 之前完成初始化
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const CarePlusApp());
}

class CarePlusApp extends StatelessWidget {
  const CarePlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Care Plus | Senior Health Monitor',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF1FDF4),
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.loading, // 启动先到 SplashScreen
      routes: {
        AppRoutes.signup: (context) => SignUpScreen(),
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.main: (context) => home_page.HomeScreen(),
        AppRoutes.profile: (context) => profile_page.ProfileScreen(),
        AppRoutes.loading: (context) => SplashScreen(),
        AppRoutes.contactRelatives: (context) => const ContactRelativesScreen(),
        AppRoutes.profileEdit: (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return ProfileEditScreen(
            isGuardian:
                args != null ? args['isGuardian'] as bool? ?? false : false,
          );
        },
      },
      onUnknownRoute:
          (settings) => MaterialPageRoute(
            builder:
                (_) => const Scaffold(
                  body: Center(child: Text("404 - Page Not Found")),
                ),
          ),
    );
  }
}

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String loading = '/loading';
  static const String contactRelatives = '/contact-relatives';
}
