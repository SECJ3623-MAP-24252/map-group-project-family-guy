import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Care_Plus/screens/home/homepage_screen.dart';

class ContactRelativesScreen extends StatefulWidget {
  const ContactRelativesScreen({super.key});

  @override
  State<ContactRelativesScreen> createState() => _ContactRelativesScreenState();
}

class _ContactRelativesScreenState extends State<ContactRelativesScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _searchController = TextEditingController();
  final List<Map<String, String>> _contacts = [];
  final _formKey = GlobalKey<FormState>();

  List<Map<String, String>> get _filteredContacts {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _contacts;
    return _contacts
        .where((c) => c['name']!.toLowerCase().contains(query))
        .toList();
  }

  void _addOrUpdateContact({int? index}) {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();

      setState(() {
        if (index == null) {
          _contacts.add({'name': name, 'phone': phone});
        } else {
          _contacts[index] = {'name': name, 'phone': phone};
        }
        _nameController.clear();
        _phoneController.clear();
      });
      Navigator.pop(context);
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch action')),
      );
    }
  }

  void _showActions(BuildContext context, String phone) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.teal),
              title: const Text('Call'),
              onTap: () {
                Navigator.pop(context);
                _launchAction(phone, 'call');
              },
            ),
            ListTile(
              leading: const Icon(Icons.sms, color: Colors.teal),
              title: const Text('Text'),
              onTap: () {
                Navigator.pop(context);
                _launchAction(phone, 'sms');
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_call, color: Colors.teal),
              title: const Text('Video Call'),
              onTap: () {
                Navigator.pop(context);
                _launchAction(phone, 'video');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
           child: HomepageScreen(),
          ),
        ),
      ),
    );
  }

  void _showAddEditDialog({int? index}) {
    if (index != null) {
      final contact = _contacts[index];
      _nameController.text = contact['name']!;
      _phoneController.text = contact['phone']!;
    } else {
      _nameController.clear();
      _phoneController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(index == null ? 'Add Contact' : 'Edit Contact'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) =>
                    value!.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) =>
                    value!.trim().isEmpty ? 'Phone number is required' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _nameController.clear();
              _phoneController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => _addOrUpdateContact(index: index),
            child: const Text('Save', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          _navigateToHome(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contact Relatives'),
          backgroundColor: Colors.teal[700],
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddEditDialog(),
          backgroundColor: Colors.teal[700],
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Contacts',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _filteredContacts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.contacts, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              "No contacts found.",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredContacts.length,
                        itemBuilder: (_, index) {
                          final contact = _filteredContacts[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal[100],
                                child: Text(
                                  contact['name']![0].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.teal[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                contact['name']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                contact['phone']!,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              onTap: () => _showActions(context, contact['phone']!),
                              onLongPress: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                  ),
                                  builder: (_) => Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.edit, color: Colors.teal),
                                          title: const Text('Edit'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _showAddEditDialog(index: index);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.delete, color: Colors.red),
                                          title: const Text('Delete'),
                                          onTap: () {
                                            setState(() {
                                              _contacts.removeAt(index);
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
