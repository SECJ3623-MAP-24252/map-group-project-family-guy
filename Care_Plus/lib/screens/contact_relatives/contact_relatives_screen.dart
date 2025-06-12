import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

class ContactRelativesScreen extends StatefulWidget {
  const ContactRelativesScreen({super.key});

  @override
  State<ContactRelativesScreen> createState() => _ContactRelativesScreenState();
}

class _ContactRelativesScreenState extends State<ContactRelativesScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  final List<Map<String, String>> _contacts = [];

  void _addContact() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isNotEmpty && phone.isNotEmpty) {
      setState(() {
        _contacts.add({'name': name, 'phone': phone});
        _nameController.clear();
        _phoneController.clear();
      });
    }
  }

  Future<void> _launchAction(String phone, String type) async {
    final Uri uri;

    if (type == 'call') {
      uri = Uri(scheme: 'tel', path: phone);
    } else if (type == 'sms') {
      uri = Uri(scheme: 'sms', path: phone);
    } else {
      uri = Uri.parse('https://meet.google.com');
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not launch action')));
    }
  }

  void _showActions(BuildContext context, String phone) {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Call'),
                onTap: () {
                  Navigator.pop(context);
                  _launchAction(phone, 'call');
                },
              ),
              ListTile(
                leading: const Icon(Icons.sms),
                title: const Text('Text'),
                onTap: () {
                  Navigator.pop(context);
                  _launchAction(phone, 'sms');
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_call),
                title: const Text('Video Call'),
                onTap: () {
                  Navigator.pop(context);
                  _launchAction(phone, 'video');
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Relatives'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Contact Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addContact,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Add Contact'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (_, index) {
                  final contact = _contacts[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(contact['name']!),
                      subtitle: Text(contact['phone']!),
                      onTap: () => _showActions(context, contact['phone']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
