import 'package:flutter/material.dart';

// 引入 profile_screen.dart 并用命名空间避免冲突
import 'package:Care_Plus/screens/profile/profile_screen.dart' as profile_page;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 切换页面，第三个页面用 profile_page.ProfileScreen
  final List<Widget> _pages = [
    HomeScreen(),
    MonitorScreen(),
    profile_page.ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart),
            label: 'Monitor',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Care+'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/default.png', width: 150, height: 150),
            const SizedBox(height: 20),
            const Text(
              'Welcome to the Senior Health Monitor App',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class MonitorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Monitoring'), centerTitle: true),
      body: const Center(
        child: Text(
          'Live health data will appear here.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
