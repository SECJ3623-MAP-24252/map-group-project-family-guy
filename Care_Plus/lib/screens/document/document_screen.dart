import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/report_upload.dart';

class HealthDataPage extends StatefulWidget {
  final String profileId;

  const HealthDataPage({Key? key, required this.profileId}) : super(key: key);

  @override
  State<HealthDataPage> createState() => _HealthDataPageState();
}

class _HealthDataPageState extends State<HealthDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _systolicCtrl = TextEditingController();
  final _diastolicCtrl = TextEditingController();

  String? _name;
  int? _age;
  double? _height;
  double? _weight;

  bool _isLoading = false;
  String? _photoUrl;

  File? _photo;
  List<File> _bloodReports = [];
  List<File> _urineReports = [];
  List<File> _historyDocs = [];
  List<String> _bloodUrls = [];
  List<String> _urineUrls = [];
  List<String> _historyUrls = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final doc =
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(widget.profileId)
            .get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _name = data['name'] as String?;
        _age = (data['age'] as num?)?.toInt();
        _height = (data['height'] as num?)?.toDouble();
        _weight = (data['weight'] as num?)?.toDouble();
        // If you have saved previous BP readings:
        _systolicCtrl.text = (data['systolic']?.toString() ?? '');
        _diastolicCtrl.text = (data['diastolic']?.toString() ?? '');
        _photoUrl = data['photoUrl'] as String?;
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final systolic = int.tryParse(_systolicCtrl.text) ?? 0;
      final diastolic = int.tryParse(_diastolicCtrl.text) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      final id = widget.profileId;

      Future<String> upload(File file, String path) async {
        final ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(file);
        return ref.getDownloadURL();
      }

      Future<List<String>> uploadList(List<File> files, String folder) async {
        return Future.wait(
          files.asMap().entries.map(
            (entry) => upload(entry.value, '$folder/${entry.key}_$now'),
          ),
        );
      }

      String? photoUrl;
      if (_photo != null) {
        photoUrl = await upload(_photo!, 'profiles/$id/photo_$now.jpg');
      }

      final bloodUrls = await uploadList(_bloodReports, 'profiles/$id/blood');
      final urineUrls = await uploadList(_urineReports, 'profiles/$id/urine');
      final historyUrls = await uploadList(
        _historyDocs,
        'profiles/$id/history',
      );

      await FirebaseFirestore.instance.collection('profiles').doc(id).set({
        'systolic': systolic,
        'diastolic': diastolic,
        'photoUrl': photoUrl,
        'bloodUrls': bloodUrls,
        'urineUrls': urineUrls,
        'historyUrls': historyUrls,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      setState(() {
        _photoUrl = photoUrl;
        _bloodUrls = bloodUrls;
        _urineUrls = urineUrls;
        _historyUrls = historyUrls;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile saved')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: \$e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _photo = File(picked.path));
    }
  }

  Future<void> _pickFileByLabel(String label) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      final files = result.paths.map((p) => File(p!)).toList();
      setState(() {
        switch (label) {
          case 'Blood Test':
            _bloodReports.addAll(files);
            break;
          case 'Urine Test':
            _urineReports.addAll(files);
            break;
          case 'History Docs':
            _historyDocs.addAll(files);
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FDF2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1FDF2),
        title: const Text('Health Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveProfile,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (!_isLoading) ...[
                  if (_name != null)
                    Text('Name: \$_name', style: const TextStyle(fontSize: 16)),
                  if (_age != null)
                    Text('Age: \$_age', style: const TextStyle(fontSize: 16)),
                  if (_height != null)
                    Text(
                      'Height: \${_height} cm',
                      style: const TextStyle(fontSize: 16),
                    ),
                  if (_weight != null)
                    Text(
                      'Weight: \${_weight} kg',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _systolicCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Systolic (高压)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator:
                                    (v) =>
                                        v == null || v.isEmpty
                                            ? 'Required'
                                            : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _diastolicCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Diastolic (低压)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator:
                                    (v) =>
                                        v == null || v.isEmpty
                                            ? 'Required'
                                            : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: _pickPhoto,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                _photo != null
                                    ? FileImage(_photo!)
                                    : (_photoUrl != null
                                            ? NetworkImage(_photoUrl!)
                                            : null)
                                        as ImageProvider?,
                            child:
                                _photo == null && _photoUrl == null
                                    ? const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white70,
                                      size: 30,
                                    )
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ReportUpload(
                          title: 'Blood Test',
                          files: _bloodReports,
                          urls: _bloodUrls,
                          onUploadTap: () => _pickFileByLabel('Blood Test'),
                          onCameraTap: () {},
                        ),
                        const Divider(),
                        ReportUpload(
                          title: 'Urine Test',
                          files: _urineReports,
                          urls: _urineUrls,
                          onUploadTap: () => _pickFileByLabel('Urine Test'),
                          onCameraTap: () {},
                        ),
                        const Divider(),
                        ReportUpload(
                          title: 'History Docs',
                          files: _historyDocs,
                          urls: _historyUrls,
                          onUploadTap: () => _pickFileByLabel('History Docs'),
                          onCameraTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
