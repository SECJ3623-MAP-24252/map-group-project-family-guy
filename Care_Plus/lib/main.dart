// main.dart (Updated with Contact functionality)
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'screens/relative/chat.dart';
import 'screens/contacts/contact_list_screen.dart';
import 'viewmodels/appointment_viewmodel.dart';
import 'viewmodels/medicine_viewmodel.dart';
import 'viewmodels/contact_viewmodel.dart';
import 'screens/home/homepage_screen.dart' as home_page;
import 'screens/home/old_homepage_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/login/signup_screen.dart';
import 'screens/profile/profile_screen.dart' as profile_page;
import 'screens/profile/profile_edit_screen.dart';
import 'shared/splash_screen.dart';
import 'screens/appointment/appointment_list_page.dart';
import 'screens/relative/relative_list_page.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:Care_Plus/screens/hospital/hospital_map_logic.dart';
import 'package:Care_Plus/screens/hospital/hospital_map_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBuipbmUvwBrYmtky-RH6519YIFoj9FWoI",
        authDomain: "careplus-c1a15.firebaseapp.com",
        databaseURL: "https://careplus-c1a15-default-rtdb.firebaseio.com",
        projectId: "careplus-c1a15",
        storageBucket: "careplus-c1a15.firebasestorage.app",
        messagingSenderId: "285406731152",
        appId: "1:285406731152:web:e82d4b75e0d7718a2c3115",
        measurementId: "G-EYE0W03VLZ",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  tz_data.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kuala_Lumpur'));

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(android: androidInit),
  );

  const channel = AndroidNotificationChannel(
    'appt_channel',
    'Appointment Reminders',
    description: 'Channel for appointment notifications',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppointmentViewModel(flutterLocalNotificationsPlugin),
        ),
        ChangeNotifierProvider(create: (_) => MedicineViewModel()),
        ChangeNotifierProvider(create: (_) => ContactViewModel()),
      ],
      child: const CarePlusApp(),
    ),
  );
}

class CarePlusApp extends StatelessWidget {
  const CarePlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Care Plus | Senior Health Monitor',
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.loading,
      routes: {
        AppRoutes.signup: (c) => SignUpScreen(),
        AppRoutes.login: (c) => const LoginScreen(),
        AppRoutes.main: (c) => const MainScaffold(),
        AppRoutes.profile: (c) => const profile_page.ProfileScreen(),
        AppRoutes.loading:
            (c) => SplashScreen(
              onFinished: () {
                Navigator.of(c).pushReplacementNamed(AppRoutes.main);
              },
            ),
        AppRoutes.contacts: (c) => const ContactListScreen(),
        AppRoutes.contactRelatives:
            (c) =>
                const ChatPage(name: 'son', imagePath: 'assets/images/man.png'),
        AppRoutes.profileEdit: (c) {
          final args =
              ModalRoute.of(c)?.settings.arguments as Map<String, dynamic>?;
          return ProfileEditScreen(
            isGuardian: args?['isGuardian'] as bool? ?? false,
          );
        },
      },
      onUnknownRoute:
          (_) => MaterialPageRoute(
            builder:
                (_) => const Scaffold(
                  body: Center(child: Text("404 - Page Not Found")),
                ),
          ),
    );
  }
}

class AppRoutes {
  static const signup = '/signup';
  static const login = '/login';
  static const main = '/main';
  static const profile = '/profile';
  static const profileEdit = '/profile/edit';
  static const loading = '/loading';
  static const contacts = '/contacts';
  static const contactRelatives = '/contact-relatives';
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    home_page.HomepageScreen(),
    AppointmentListPage(),
    ContactListScreen(),
    profile_page.ProfileScreen(),
  ];

  void _onTap(int idx) => setState(() => _currentIndex = idx);

  void _goToOldHomepage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => OldHomepageScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _goToOldHomepage,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.apps, color: Colors.purple, size: 32),
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () => _onTap(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        color:
                            _currentIndex == 0
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                          color:
                              _currentIndex == 0
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => _onTap(1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color:
                            _currentIndex == 1
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                      ),
                      Text(
                        'Appointments',
                        style: TextStyle(
                          color:
                              _currentIndex == 1
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 56),
              Expanded(
                child: InkWell(
                  onTap: () => _onTap(2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.contacts,
                        color:
                            _currentIndex == 2
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                      ),
                      Text(
                        'Contacts',
                        style: TextStyle(
                          color:
                              _currentIndex == 2
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => _onTap(3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color:
                            _currentIndex == 3
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                          color:
                              _currentIndex == 3
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
