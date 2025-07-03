// lib/screens/relative/relative_list_page.dart
import 'package:flutter/material.dart';
import 'chat.dart';

class RelativeListPage extends StatelessWidget {
  const RelativeListPage({Key? key}) : super(key: key);

  final List<Map<String, String>> relatives = const [
    {'name': 'Son', 'image': 'assets/images/man.png'},
    {'name': 'Daughter', 'image': 'assets/images/woman.png'},
    // Tambahkan lagi jika perlu
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FDF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
        title: const Text(
          'Contact Relatives',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: relatives.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final relative = relatives[index];
          return ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: Colors.white,
            leading: CircleAvatar(
              backgroundImage: AssetImage(relative['image']!),
              radius: 28,
            ),
            title: Text(
              relative['name']!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
          );
        },
      ),
    );
  }
}
