// import 'package:flutter/material.dart';
// import 'package:Care_Plus/screens/profile/profile_screen.dart' as profile_page;
// import 'package:Care_Plus/screens/Home/ManageMedicineSchedule.dart';

// class HomeScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> features = [
//     {'title': 'Appointment Reminder', 'icon': Icons.calendar_today},
//     {'title': 'Add Medicine Reminder', 'icon': Icons.medication_outlined},
//     {'title': 'Locate Nearby Hospital', 'icon': Icons.local_hospital},
//     {'title': 'Contact Relatives', 'icon': Icons.phone_in_talk},
//     {'title': 'Emergency Location', 'icon': Icons.emergency_share},
//     {'title': 'Documents', 'icon': Icons.description_outlined},
//     {'title': 'Node', 'icon': Icons.device_hub},
//     {'title': 'Relative', 'icon': Icons.group},
//   ];

//   void _navigateToComingSoon(BuildContext context, String title) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ComingSoonPage(title: title)),
//     );
//   }

//   void _navigateToSettings(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const ComingSoonPage(title: 'Settings'),
//       ),
//     );
//   }

//   void _logout(BuildContext context) {
//     Navigator.pushReplacementNamed(
//       context,
//       '/login',
//     ); // 确保你在 main.dart 注册了 '/login' 路由
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeColor = const Color.fromARGB(255, 2, 95, 59);

//     return Scaffold(
//       appBar: AppBar(
//         title: RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: '',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 24,
//                   color: Color.fromARGB(255, 3, 3, 3),
//                   letterSpacing: 1.2,
//                 ),
//               ),
//               TextSpan(
//                 text: 'Care Plus',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 30,
//                   color: Color.fromARGB(255, 3, 3, 3),

//                   fontStyle: FontStyle.italic,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         backgroundColor: Colors.transparent, // 背景透明
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person),
//             tooltip: 'Profile',
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => profile_page.ProfileScreen(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Color.fromARGB(255, 176, 201, 152),
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 30,
//                   color: Color.fromARGB(255, 3, 3, 3),

//                   fontStyle: FontStyle.italic,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text('Settings', style: TextStyle(fontSize: 18)),
//               onTap: () => _navigateToSettings(context),
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Logout', style: TextStyle(fontSize: 18)),
//               onTap: () => _logout(context),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: const Color.fromARGB(255, 236, 243, 230),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: features.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 20,
//                   crossAxisSpacing: 20,
//                   childAspectRatio: 1,
//                 ),
//                 itemBuilder: (context, index) {
//                   final item = features[index];
//                   return Material(
//                     color: const Color.fromARGB(255, 216, 242, 203),
//                     borderRadius: BorderRadius.circular(16),
//                     elevation: 4,
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(16),
//                       onTap:
//                           () => _navigateToComingSoon(context, item['title']),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(item['icon'], size: 50, color: themeColor),
//                             const SizedBox(height: 16),
//                             Text(
//                               item['title'],
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(
//                                 fontSize: 20, // 字体大小调整
//                                 fontWeight: FontWeight.bold, // 加粗
//                                 fontStyle: FontStyle.italic, // 斜体
//                                 color: Color.fromARGB(255, 0, 0, 0), // 颜色
//                                 //letterSpacing: 1.1, // 字符间距
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ComingSoonPage extends StatelessWidget {
//   final String title;

//   const ComingSoonPage({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: Color.fromARGB(255, 216, 242, 203),
//       ),
//       body: const Center(
//         child: Text(
//           'Coming Soon...',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:Care_Plus/screens/home/oldhomepage.dart';
import 'package:Care_Plus/screens/profile/profile_screen.dart' as profile_page;
import 'package:Care_Plus/screens/appointment/appointment_page.dart'; // 路径请根据你实际项目调整

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
                        MaterialPageRoute(builder: (_) => BillPage()),
                      );
                    },
                  ),
                  actionButton(
                    Icons.phone_android,
                    'Relative',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MobilePage()),
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

class MobilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relative Page')),
      body: const Center(child: Text('This is the Relative Page')),
    );
  }
}
