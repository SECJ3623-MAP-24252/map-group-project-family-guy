import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  final bool isGuardian;
  const ProfileScreen({Key? key, this.isGuardian = false}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final _docRef = FirebaseFirestore.instance
      .collection('profiles_demo')
      .doc('currentProfile');

  Map<String, dynamic>? _data;
  ImageProvider? _avatarImage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final snap = await _docRef.get();
    if (snap.exists) {
      final d = snap.data()!;
      ImageProvider? avatar;
      final b64 = d['avatarBase64'] as String?;
      if (b64 != null && b64.isNotEmpty) {
        avatar = MemoryImage(base64Decode(b64));
      }
      setState(() {
        _data = d;
        _avatarImage = avatar;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _editProfile(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/profile/edit',
      arguments: {'isGuardian': widget.isGuardian},
    ).then((_) => _loadProfile());
  }

  Widget _sectionCard({required Widget child, double? width}) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade200.withOpacity(0.3),
            blurRadius: 10.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _infoRow(String label, String value, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.teal.shade700,
              fontWeight: FontWeight.w700,
              fontSize: fontSize,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBlock(
    String title,
    List<String> items,
    double titleSize,
    double itemSize,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: titleSize,
            color: Colors.teal.shade900,
          ),
        ),
        const SizedBox(height: 10.0),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '• $item',
              style: TextStyle(
                fontSize: itemSize,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 360.0;
    final double titleFontSize = isSmallScreen ? 18.0 : 22.0;
    final double subtitleFontSize = isSmallScreen ? 14.0 : 18.0;
    final double infoFontSize = isSmallScreen ? 16.0 : 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF1FDF2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1FDF2),
        elevation: 0,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: const Color.fromARGB(255, 119, 156, 125),
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize + 4.0,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => _editProfile(context),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body:
          _data == null
              ? const Center(child: CircularProgressIndicator())
              : FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 54.0,
                        backgroundImage:
                            _avatarImage ??
                            const AssetImage(
                              'assets/images/senior_profile.png',
                            ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        _data!['name'] ?? 'John Doe',
                        style: TextStyle(
                          fontSize: titleFontSize + 8.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.teal.shade900,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Age: ${_data!['age'] ?? 0}',
                            style: TextStyle(
                              color: Colors.teal.shade800,
                              fontSize: subtitleFontSize,
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Text(
                            'Height: ${_data!['height'] ?? 0} cm',
                            style: TextStyle(
                              color: Colors.teal.shade800,
                              fontSize: subtitleFontSize,
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Text(
                            'Weight: ${_data!['weight'] ?? 0} kg',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontSize: subtitleFontSize,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28.0),
                      _sectionCard(
                        width: screenWidth * 0.9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow(
                              'Email',
                              _data!['email'] ?? '',
                              infoFontSize,
                            ),
                            _infoRow(
                              'Phone',
                              _data!['phone'] ?? '',
                              infoFontSize,
                            ),
                            _infoRow(
                              'IC/Passport',
                              _data!['icPassport'] ?? '',
                              infoFontSize,
                            ),
                          ],
                        ),
                      ),
                      _sectionCard(
                        width: screenWidth * 0.9,
                        child: _infoBlock(
                          'Allergies',
                          List<String>.from(
                            (_data!['allergyHistory'] as String?)?.split(',') ??
                                [],
                          ),
                          titleFontSize,
                          infoFontSize,
                        ),
                      ),
                      _sectionCard(
                        width: screenWidth * 0.9,
                        child: _infoBlock(
                          'Medical History',
                          List<String>.from(
                            (_data!['medicalHistory'] as String?)?.split(',') ??
                                [],
                          ),
                          titleFontSize,
                          infoFontSize,
                        ),
                      ),
                      _sectionCard(
                        width: screenWidth * 0.9,
                        child: _infoBlock(
                          'Insurance & Family Doctor',
                          [
                            'Insurance: ${_data!['insurancePlan'] ?? ''}',
                            'Family Doctor: ${_data!['familyDoctor'] ?? ''}',
                          ],
                          titleFontSize,
                          infoFontSize,
                        ),
                      ),
                      _sectionCard(
                        width: screenWidth * 0.9,
                        child: _infoBlock(
                          'Emergency Contact',
                          [_data!['emergencyContact'] ?? ''],
                          titleFontSize,
                          infoFontSize,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Confirm Logout'),
                                  content: const Text(
                                    'Are you sure you want to log out?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('You have been logged out.'),
                                backgroundColor: Colors.teal,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          'Logout',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade700,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 14.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
