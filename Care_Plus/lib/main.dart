// lib/main.dart

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:Care_Plus/screens/home/homepage_screen.dart' as home_page;
import 'package:Care_Plus/screens/profile/profile_screen.dart' as profile_page;
import 'package:Care_Plus/screens/login/signup_screen.dart';
import 'package:Care_Plus/screens/login/login_screen.dart';
import 'package:Care_Plus/screens/profile/profile_edit_screen.dart';
import 'package:Care_Plus/screens/contact_relatives/contact_relatives_screen.dart';
import 'package:Care_Plus/shared/splash_screen.dart'; // ✅ updated

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBuipbmUvwBrYmtky-RH6519YIFoj9FWoI",
        authDomain: "careplus-c1a15.firebaseapp.com",
        databaseURL: "https://careplus-c1a15-default-rtdb.firebaseio.com",
        projectId: "careplus-c1a15",
        storageBucket: "careplus-c1a15.appspot.com",
        messagingSenderId: "285406731152",
        appId: "1:285406731152:web:e82d4b75e0d7718a2c3115",
        measurementId: "G-EYE0W03VLZ",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

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
      initialRoute: AppRoutes.loading,
      routes: {
        AppRoutes.signup: (context) => SignUpScreen(),
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.main: (context) => home_page.HomepageScreen(),
        AppRoutes.profile: (context) => profile_page.ProfileScreen(),
        AppRoutes.loading: (context) => SplashScreen(),
        AppRoutes.contactRelatives: (context) =>
            const ContactRelativesScreen(),
        AppRoutes.profileEdit: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return ProfileEditScreen(
            isGuardian: args != null ? args['isGuardian'] as bool? ?? false : false,
          );
        },
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const Scaffold(
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
