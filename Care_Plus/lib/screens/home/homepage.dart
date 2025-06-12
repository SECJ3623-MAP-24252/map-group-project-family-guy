import 'package:Care_Plus/screens/document/document.dart';
import 'package:flutter/material.dart';
import 'package:Care_Plus/screens/home/oldhomepage.dart';
import 'package:Care_Plus/screens/profile/profile_screen.dart' as profile_page;
import 'package:Care_Plus/screens/appointment/appointment_page.dart'; // 路径请根据你实际项目调整
import 'package:Care_Plus/screens/relative/chat.dart';
import 'package:Care_Plus/screens/hospital/hospital_map_screen.dart';


void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: WalletHomePage(),
    );
  }
}

class WalletHomePage extends StatelessWidget {
  final List<Map<String, String>> quickSendList = [
    {'name': 'son', 'image': 'assets/images/man.png'},
  ];

  final List<Map<String, dynamic>> AppointmentList = [
    {
      'icon': Icons.medication_outlined,
      'label': 'Medicine Reminder',
      'amount': '',
    },
    {
      'icon': Icons.calendar_today,
      'label': 'Doctor Appointment',
      'amount': '12 Oct, 10:00 AM',
    },
    {
      'icon': Icons.local_hospital,
      'label': 'Clinic Visit',
      'amount': '15 Oct, 3:00 PM',
    },
    {
      'icon': Icons.phone_in_talk,
      'label': 'Call Caregiver',
      'amount': 'Pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FDF2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Header with clickable avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => profile_page.ProfileScreen(),
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/senior_profile.png',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Mr john doe", style: TextStyle(fontSize: 16)),
                          Text(
                            "Welcome Back 👋",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.notifications, color: Colors.black54),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ Profile card
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black87,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            'assets/images/senior_profile.png',
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Mr. John Doe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Age: 67',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Phone: +60 12-345 6789',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Email: john.doe@email.com',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  actionButton(
                    Icons.send,
                    'Appointment',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AppointmentPage(),
                        ), // ✅ 替换为你的预约界面
                      );
                    },
                  ),

                  actionButton(
                    Icons.receipt_long,
                    'Documents',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HealthDataPage(),
                        ),
                      );
                    },
                  ),
                  actionButton(
                    Icons.phone_android,
                    'Relative',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ChatPage(
                                name: 'son',
                                imagePath: 'assets/images/man.png',
                              ),
                        ),
                      );
                    },
                  ),

                  actionButton(
          Icons.map,
      'Hospital',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HospitalMapScreen()),
        );
      },
    ),
                  actionButton(
                    Icons.more_horiz,
                    'More',
                    highlight: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => oldHomeScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Quick Send
              const Text(
                "Quick Send",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      quickSendList.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(item['image']!),
                              ),
                              const SizedBox(height: 5),
                              Text(item['name']!),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Recent Appointment
              const Text(
                "Recent Appointment",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children:
                    AppointmentList.map((activity) {
                      return ListTile(
                        leading: Icon(activity['icon'], color: Colors.black54),
                        title: Text(activity['label']),
                        trailing: Text(
                          activity['amount'],
                          style: TextStyle(
                            color:
                                activity['amount'].toString().startsWith('-')
                                    ? Colors.red
                                    : Colors.green,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget actionButton(
    IconData icon,
    String label, {
    bool highlight = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor:
                highlight ? const Color(0xFFC6F5C6) : const Color(0xFFE7F9E7),
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }
}

// ⬇️ Dummy Pages for Navigation
class SendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Page')),
      body: const Center(child: Text('This is the Appointment Page')),
    );
  }
}

class BillPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Documents Page')),
      body: const Center(child: Text('This is the Documents Page')),
    );
  }
}
