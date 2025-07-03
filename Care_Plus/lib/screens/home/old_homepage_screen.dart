import 'package:Care_Plus/screens/document/document.dart';
import 'package:flutter/material.dart';
import 'package:Care_Plus/screens/profile/profile_screen.dart' as profile_page;
import 'package:Care_Plus/screens/home/manage_medicine_screen.dart';
//import 'package:Care_Plus/screens/home/nearby_hospitals_screen.dart';
import 'package:Care_Plus/screens/relative/chat.dart';
import 'package:Care_Plus/screens/hospital/hospital_map_logic.dart';
import 'package:Care_Plus/screens/hospital/hospital_map_screen.dart';

class OldHomepageScreen extends StatelessWidget {
  static const List<Map<String, dynamic>> features = <Map<String, dynamic>>[
    const {'title': 'Appointment Reminder', 'icon': Icons.calendar_today},
    const {'title': 'Add Medicine Reminder', 'icon': Icons.medication_outlined},
    const {'title': 'Locate Nearby Hospital', 'icon': Icons.local_hospital},
    const {'title': 'Contact Relatives', 'icon': Icons.phone_in_talk},
    const {'title': 'Emergency Location', 'icon': Icons.emergency_share},
    const {'title': 'Documents', 'icon': Icons.description_outlined},
    const {'title': 'Node', 'icon': Icons.device_hub},
    const {'title': 'Relative', 'icon': Icons.group},
  ];

  const OldHomepageScreen({Key? key}) : super(key: key);

  void _navigateToFeature(BuildContext context, String title) {
    switch (title) {
      case 'Add Medicine Reminder':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ManageMedicineScreen()),
        );
        break;
      case 'Contact Relatives':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => const ChatPage(
                  name: 'son',
                  imagePath: 'assets/images/man.png',
                ),
          ),
        );
        break;
      case 'Documents':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HealthDataPage()),
        );
        break;
      case 'Locate Nearby Hospital':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HospitalMapScreen()),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ComingSoonPage(title: title)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.teal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Plus'),
        backgroundColor: const Color(0xFFF1FDF2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const profile_page.ProfileScreen(),
                ),
              );
            },
          ),
        ],
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
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFF1FDF2),
      ),
      body: const Center(
        child: Text(
          'Coming Soon...',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
