import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:Care_Plus/screens/profile/profile_screen.dart' as profile_page;
import '../appointment/appointment_list_page.dart';
import 'package:Care_Plus/screens/document/document_screen.dart';
import 'package:Care_Plus/screens/relative/chat.dart';
import 'package:Care_Plus/screens/home/old_homepage_screen.dart';
import 'package:Care_Plus/widgets/action_button.dart';
import '../../viewmodels/appointment_viewmodel.dart';

/// Home page body
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
    final quickSendList = [
      {'name': 'Son', 'image': 'assets/images/man.png'},
    ];

    return SafeArea(
      child: Container(
        color: const Color(0xFFF1FDF2), // page background
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header + Profile
              StreamBuilder<DocumentSnapshot>(
                stream: _profileDoc.snapshots(),
                builder: (context, snap) {
                  var name = 'Mr. John Doe';
                  String avatarAsset = 'assets/images/senior_profile.png';
                  int age = 67;
                  String phone = '+60 12-345 6789';
                  String email = 'john.doe@email.com';
                  ImageProvider avatar = AssetImage(avatarAsset);

                  if (snap.hasData && snap.data!.exists) {
                    final data = snap.data!.data() as Map<String, dynamic>;
                    if (data['avatarBase64'] != null &&
                        data['avatarBase64'].isNotEmpty) {
                      avatar = MemoryImage(base64Decode(data['avatarBase64']));
                    }
                    name = data['name'] ?? name;
                    age =
                        (data['age'] is int)
                            ? data['age']
                            : int.tryParse(data['age'].toString()) ?? age;
                    phone = data['phone'] ?? phone;
                    email = data['email'] ?? email;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // top row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                const profile_page.ProfileScreen(),
                                      ),
                                    ),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundImage: avatar,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(fontSize: 16),
                                  ),
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
                          const Icon(
                            Icons.notifications,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // profile card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            CircleAvatar(radius: 30, backgroundImage: avatar),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Age: $age',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Phone: $phone',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Email: $email',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
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
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AppointmentListPage(),
                          ),
                        ),
                  ),
                  ActionButton(
                    icon: Icons.receipt_long,
                    label: 'Documents',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HealthDataPage(),
                          ),
                        ),
                  ),
                  ActionButton(
                    icon: Icons.phone_android,
                    label: 'Relative',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => const ChatPage(
                                  name: 'Son',
                                  imagePath: 'assets/images/man.png',
                                ),
                          ),
                        ),
                  ),
                  ActionButton(
                    icon: Icons.more_horiz,
                    label: 'More',
                    highlight: true,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OldHomepageScreen(),
                          ),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Send
              const Text(
                'Quick Send',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      quickSendList.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(item['image']!),
                              ),
                              const SizedBox(height: 6),
                              Text(item['name']!),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 32),

              // Recent Appointments — 卡片式展示
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Appointments',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AppointmentListPage(),
                          ),
                        ),
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Consumer<AppointmentViewModel>(
                builder: (context, vm, _) {
                  if (vm.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final recent = List.of(vm.appointments)
                    ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
                  if (recent.isEmpty) {
                    return const Text('No upcoming appointments.');
                  }
                  return Column(
                    children:
                        recent.take(3).map((appt) {
                          final parts = appt.patientName.split(' - ');
                          final hospital = parts.isNotEmpty ? parts[0] : '';
                          final doctor = parts.length > 1 ? parts[1] : '';
                          final formatted =
                              '${appt.dateTime.year}-${appt.dateTime.month.toString().padLeft(2, '0')}-${appt.dateTime.day.toString().padLeft(2, '0')} '
                              '${appt.dateTime.hour.toString().padLeft(2, '0')}:${appt.dateTime.minute.toString().padLeft(2, '0')}';
                          return Card(
                            color: const Color.fromARGB(
                              255,
                              209,
                              246,
                              211,
                            ), // card background
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              leading: const Icon(
                                Icons.local_hospital,
                                size: 32,
                                color: Colors.teal,
                              ),
                              title: Text(
                                hospital,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Dr. $doctor'),
                                    const SizedBox(height: 4),
                                    Text(formatted),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.black54,
                                ),
                                onPressed:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => const AppointmentListPage(),
                                      ),
                                    ),
                              ),
                            ),
                          );
                        }).toList(),
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
