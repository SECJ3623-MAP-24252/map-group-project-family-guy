import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:Care_Plus/screens/profile/profile_screen.dart' as profile_page;
import '../appointment/appointment_list_page.dart';
import 'package:Care_Plus/screens/relative/chat.dart';
import 'package:Care_Plus/widgets/action_button.dart';
import '../../viewmodels/appointment_viewmodel.dart';
import '../../viewmodels/medicine_viewmodel.dart';
import '../../widgets/medicine_card.dart';
import '../../widgets/appointment_card.dart';
import 'manage_medicine_screen.dart';
import '../appointment/appointment_edit_page.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final _profileDoc = FirebaseFirestore.instance.collection('profiles_demo').doc('currentProfile');
  bool showReminderPanel = false;
  List<Map<String, dynamic>> reminderList = [];

  @override
  void initState() {
    super.initState();
    loadLatestReminders();
  }

  Future<void> loadLatestReminders() async {
  List<Map<String, dynamic>> tempList = [];


String _monthStr(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[month - 1];
}
  // 拿 medicine 的最新一条
  final medSnap = await FirebaseFirestore.instance
      .collection('medicines')
      .orderBy('createdAt', descending: true)
      .limit(1)
      .get();

  if (medSnap.docs.isNotEmpty) {
    final data = medSnap.docs.first.data();
    final name = data['name'];
    final times = List<String>.from(data['times'] ?? []);
    final days = List<String>.from(data['days'] ?? []);
    tempList.add({
      'title': 'Take Medicine: $name',
      'time': '${times.isNotEmpty ? times[0] : 'N/A'}, ${days.isNotEmpty ? days[0] : 'N/A'}',
      'status': 'Upcoming',
      'icon': Icons.medication_outlined,
    });
  }

  // 拿 appointment 的最新一条
  final appSnap = await FirebaseFirestore.instance
      .collection('appointments')
      .orderBy('dateTime', descending: true)
      .limit(1)
      .get();

  if (appSnap.docs.isNotEmpty) {
    final data = appSnap.docs.first.data();
    final patient = data['patientName'] ?? 'Unknown Patient';
    final rawDate = data['dateTime']?.toString() ?? 'Unknown Date';

    String timeStr = rawDate;
    try {
      final dt = DateTime.parse(rawDate);
      timeStr =
          '${dt.day.toString().padLeft(2, '0')} ${_monthStr(dt.month)} ${dt.year}, ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      // fallback
    }

    tempList.add({
      'title': 'Appointment: $patient',
      'time': timeStr,
      'status': 'Upcoming',
      'icon': Icons.calendar_today,
    });
  }

  // 设置提醒
  setState(() {
    reminderList = tempList;
  });



  print('✅ 加载完毕 reminderList：共 ${tempList.length} 条');
}


  



  @override
  Widget build(BuildContext context) {
    final medicineVM = Provider.of<MedicineViewModel>(context);
    final appointmentVM = Provider.of<AppointmentViewModel>(context);

    const relatives = [
      {'name': 'Son', 'image': 'assets/images/man.png'},
      {'name': 'Daughter', 'image': 'assets/images/woman.png'},
    ];
    const double avatarSize = 64;

    return Stack(
      children: [
        SafeArea(
          child: Container(
            color: const Color(0xFFF1FDF2),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            
              // -------------------- Profile Card --------------------
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

                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 36, backgroundImage: avatar),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.teal,
                                      ),
                                      onPressed:
                                          () => Navigator.pushNamed(
                                            context,
                                            '/profile/edit',
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.cake,
                                      size: 18,
                                      color: Color.fromARGB(255, 158, 158, 158),
                                    ),
                                    const SizedBox(width: 4),
                                    Text('Age: $age'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(phone),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.email,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(email),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // -------------------- Contact Relatives --------------------
               Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Contact Relatives',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(
                          reminderList.isEmpty ? Icons.notifications_none : Icons.notifications,
                          color: reminderList.isEmpty ? Colors.grey : Colors.red,
                        ),
                        tooltip: 'Show Reminders',
                        onPressed: () {
                          setState(() {
                            showReminderPanel = !showReminderPanel;
                          });
                        },
                      ),
                    ],
                  ),
              const SizedBox(height: 12),
              SizedBox(
                height: avatarSize + 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: relatives.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final relative = relatives[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ChatPage(
                                  name: relative['name']!,
                                  imagePath: relative['image']!,
                                ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: avatarSize / 2,
                            backgroundImage: AssetImage(relative['image']!),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: avatarSize + 10,
                            child: Text(
                              relative['name']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),

              // -------------------- Upcoming Appointments --------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming Appointments',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.teal),
                        tooltip: 'Add Appointment',
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AppointmentEditPage(),
                              ),
                            ),
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
                ],
              ),
              const SizedBox(height: 12),
              if (appointmentVM.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (appointmentVM.appointments.isEmpty)
                const Text('No upcoming appointments.')
              else
                Column(
                  children:
                      appointmentVM.appointments
                          .toList()
                          .take(3)
                          .map((appt) => AppointmentCard(appointment: appt))
                          .toList(),
                ),

              const SizedBox(height: 32),

              // -------------------- Recent Medicines --------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Medicines',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.teal),
                        tooltip: 'Add Medicine',
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ManageMedicineScreen(),
                            ),
                          );
                        },
                      ),
                      TextButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ManageMedicineScreen(),
                            ),
                          );
                        },
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              StreamBuilder(
                stream: medicineVM.medicinesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No medicines scheduled.');
                  }

                  final docs = snapshot.data!.docs.take(3).toList();

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final name = data['name'] ?? '-';
                      final dose = data['dose'] ?? '-';
                      final times = (data['times'] as List).join(', ');

                      return MedicineCard(
                        name: name,
                        dose: dose,
                        times: times,
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ManageMedicineScreen(),
                              ),
                            ),
                        onDismissed: (_) async {
                          await medicineVM.deleteMedicine(doc.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Medicine deleted')),
                          );
                        },
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 32),
             ],
              ),
            ),
          ),
        ),
        // 🔔 提醒面板叠加在页面上
    

    if (showReminderPanel)
      Positioned.fill(
        child: GestureDetector(
          onTap: () => setState(() => showReminderPanel = false),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.6,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: reminderList.isEmpty
                    ? const Center(child: Text("No Reminders"))
                    : ListView.builder(
                        itemCount: reminderList.length,
                        itemBuilder: (context, index) {
                          final item = reminderList[index];
                          return Dismissible(
                            key: Key(item['title'] + index.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (dir) {
                              setState(() {
                                reminderList.removeAt(index);
                                if (reminderList.isEmpty) {
                                  showReminderPanel = false;
                                }
                              });
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: Icon(item['icon']),
                                title: Text(item['title']),
                                subtitle: item['time'] != null ? Text(item['time']) : null,
                                trailing: Text(
                                  item['status'],
                                  style: TextStyle(
                                    color: item['status'] == 'Pending' ? Colors.red : Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
      ),
      ],
  

      
    );
  }
}