import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../viewmodels/contact_viewmodel.dart';
import '../../models/contact_model.dart';
import 'add_contact_screen.dart';
import '../relative/chat.dart';
import '../../calls/vidio_call_page.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({Key? key}) : super(key: key);

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContactViewModel>(context, listen: false).initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FDF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
        title: const Text('Contacts', style: TextStyle(color: Colors.black87)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddContactScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<ContactViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: viewModel.searchContacts,
                  decoration: InputDecoration(
                    hintText: 'Search contacts...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                viewModel.clearSearch();
                              },
                            )
                            : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Contacts List
              Expanded(child: _buildContactsList(viewModel)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContactsList(ContactViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Error: ${viewModel.error}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: viewModel.refresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (viewModel.contacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contacts_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              viewModel.searchQuery.isEmpty
                  ? 'No contacts yet'
                  : 'No contacts found',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.searchQuery.isEmpty
                  ? 'Tap the + button to add your first contact'
                  : 'Try a different search term',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: viewModel.contacts.length,
        itemBuilder: (context, index) {
          final contact = viewModel.contacts[index];
          return _buildContactCard(contact, viewModel);
        },
      ),
    );
  }

  Widget _buildContactCard(Contact contact, ContactViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey.shade300,
          backgroundImage:
              contact.imagePath != null ? AssetImage(contact.imagePath!) : null,
          child:
              contact.imagePath == null
                  ? Text(
                    contact.name.isNotEmpty
                        ? contact.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  : null,
        ),
        title: Text(
          contact.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(contact.phoneNumber),
            Text(contact.email, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, contact, viewModel),
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: 'chat', child: Text('Chat')),
                const PopupMenuItem(value: 'call', child: Text('Call')),
                const PopupMenuItem(value: 'video', child: Text('Video Call')),
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
        ),
        onTap: () => _showContactActions(contact, viewModel),
      ),
    );
  }

  void _showContactActions(Contact contact, ContactViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.chat,
                      label: 'Chat',
                      onPressed: () {
                        Navigator.pop(context);
                        _startChat(contact);
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.call,
                      label: 'Call',
                      onPressed: () {
                        Navigator.pop(context);
                        _makeCall(contact.phoneNumber);
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.videocam,
                      label: 'Video',
                      onPressed: () {
                        Navigator.pop(context);
                        _startVideoCall(contact);
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.edit,
                      label: 'Edit',
                      onPressed: () {
                        Navigator.pop(context);
                        _editContact(contact);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blueAccent,
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _handleMenuAction(
    String action,
    Contact contact,
    ContactViewModel viewModel,
  ) {
    switch (action) {
      case 'chat':
        _startChat(contact);
        break;
      case 'call':
        _makeCall(contact.phoneNumber);
        break;
      case 'video':
        _startVideoCall(contact);
        break;
      case 'edit':
        _editContact(contact);
        break;
      case 'delete':
        _deleteContact(contact, viewModel);
        break;
    }
  }

  void _startChat(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ChatPage(
              name: contact.name,
              imagePath:
                  contact.imagePath ?? 'assets/images/default_avatar.png',
            ),
      ),
    );
  }

  void _makeCall(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to make call')));
    }
  }

  void _startVideoCall(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VideoCallPage()),
    );
  }

  void _editContact(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddContactScreen(contact: contact)),
    );
  }

  void _deleteContact(Contact contact, ContactViewModel viewModel) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Contact'),
            content: Text('Are you sure you want to delete ${contact.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final success = await viewModel.deleteContact(contact.id);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contact deleted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
