import 'package:flutter/material.dart';
import 'package:Care_Plus/screens/profile/profile_screen.dart' as profile_page;
import 'package:Care_Plus/screens/Home/ManageMedicineSchedule.dart';
import 'package:Care_Plus/screens/contact_relatives/contact_relatives_screen.dart';
import 'package:Care_Plus/screens/hospital/hospital_map_screen.dart';



              



class oldHomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {'title': 'Appointment Reminder', 'icon': Icons.calendar_today},
    {'title': 'Add Medicine Reminder', 'icon': Icons.medication_outlined},
    {'title': 'Locate Nearby Hospital', 'icon': Icons.local_hospital},
    {'title': 'Contact Relatives', 'icon': Icons.phone_in_talk},
    {'title': 'Emergency Location', 'icon': Icons.emergency_share},
    {'title': 'Documents', 'icon': Icons.description_outlined},
    {'title': 'Node', 'icon': Icons.device_hub},
    {'title': 'Relative', 'icon': Icons.group},
  ];

  void _navigateToFeature(BuildContext context, String title) {
    if (title == 'Add Medicine Reminder') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ManageMedicineSchedule()),
      );
    } else if (title == 'Locate Nearby Hospital') {              // ★ 新增
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HospitalMapScreen()),
    );
    }
  else if (title == 'Contact Relatives') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ContactRelativesScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ComingSoonPage(title: title)),
      );
    }
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ComingSoonPage(title: 'Settings'),
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.teal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Plus'),
        backgroundColor: themeColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => profile_page.ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings', style: TextStyle(fontSize: 18)),
              onTap: () => _navigateToSettings(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout', style: TextStyle(fontSize: 18)),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: features.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = features[index];
                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    elevation: 4,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _navigateToFeature(context, item['title']),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(item['icon'], size: 50, color: themeColor),
                            const SizedBox(height: 16),
                            Text(
                              item['title'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ComingSoonPage extends StatelessWidget {
  final String title;

  const ComingSoonPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.teal),
      body: const Center(
        child: Text(
          'Coming Soon...',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
