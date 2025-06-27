import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Care_Plus/screens/profile/profile_screen.dart' as profile_page;
import '../appointment/appointment_list_page.dart';
import 'package:Care_Plus/screens/document/document_screen.dart';
import 'package:Care_Plus/screens/relative/chat.dart';
import 'package:Care_Plus/screens/home/old_homepage_screen.dart';
import 'package:Care_Plus/widgets/action_button.dart';

/// 主页内容，仅作为 MainScaffold 的 body
class HomepageScreen extends StatefulWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final _profileDoc = FirebaseFirestore.instance
      .collection('profiles_demo')
      .doc('currentProfile');

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> quickSendList = [
      {'name': 'son', 'image': 'assets/images/man.png'},
    ];

    final List<Map<String, dynamic>> appointmentList = [
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

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header + Profile Card from Firestore
            StreamBuilder<DocumentSnapshot>(
              stream: _profileDoc.snapshots(),
              builder: (context, snap) {
                // default data
                var name = 'Mr. John Doe';
                String avatarAsset = 'assets/images/senior_profile.png';
                int age = 67;
                String phone = '+60 12-345 6789';
                String email = 'john.doe@email.com';
                ImageProvider avatar = AssetImage(avatarAsset);

                if (snap.hasData && snap.data!.exists) {
                  final data = snap.data!.data() as Map<String, dynamic>;
                  if (data['avatarBase64'] != null && data['avatarBase64'].isNotEmpty) {
                    avatar = MemoryImage(base64Decode(data['avatarBase64']));
                  }
                  name = data['name'] ?? name;
                  age = (data['age'] is int) ? data['age'] : int.tryParse(data['age'].toString()) ?? age;
                  phone = data['phone'] ?? phone;
                  email = data['email'] ?? email;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const profile_page.ProfileScreen(),
                                ),
                              ),
                              child: CircleAvatar(backgroundImage: avatar),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: const TextStyle(fontSize: 16)),
                                const Text(
                                  'Welcome Back 👋',
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
                    // profile card
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
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: avatar,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Age: $age',
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Phone: $phone',
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Email: $email',
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionButton(
                  icon: Icons.send,
                  label: 'Appointment',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AppointmentListPage()),
                  ),
                ),
                ActionButton(
                  icon: Icons.receipt_long,
                  label: 'Documents',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HealthDataPage()),
                  ),
                ),
                ActionButton(
                  icon: Icons.phone_android,
                  label: 'Relative',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChatPage(
                        name: 'son',
                        imagePath: 'assets/images/man.png',
                      ),
                    ),
                  ),
                ),
                ActionButton(
                  icon: Icons.more_horiz,
                  label: 'More',
                  highlight: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OldHomepageScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Quick Send
            const Text(
              'Quick Send',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: quickSendList.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      children: [
                        CircleAvatar(backgroundImage: AssetImage(item['image']!)),
                        const SizedBox(height: 5),
                        Text(item['name']!),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Recent Appointments
            const Text(
              'Recent Appointment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: appointmentList.map((activity) {
                return ListTile(
                  leading: Icon(activity['icon'], color: Colors.black54),
                  title: Text(activity['label']),
                  trailing: Text(
                    activity['amount'],
                    style: TextStyle(
                      color: activity['amount'].toString().startsWith('Pending')
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
    );
  }
}