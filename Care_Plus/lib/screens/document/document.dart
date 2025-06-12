import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

/// 页面：专业版老年人健康信息管理
class HealthDataPage extends StatefulWidget {
  const HealthDataPage({Key? key}) : super(key: key);

  @override
  _HealthDataPageState createState() => _HealthDataPageState();
}

class _HealthDataPageState extends State<HealthDataPage> {
  // 基本信息
  final _infoKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  String _gender = 'Male';
  final _contactCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  // 医疗数据与备注
  final _dataKey = GlobalKey<FormState>();
  final _notesCtrl = TextEditingController();

  // 上传图片与文件
  File? _photo;
  final ImagePicker _imgPicker = ImagePicker();

  List<File> _bloodReports = [];
  List<File> _urineReports = [];
  List<File> _historyDocs = [];

  // 选择照片
  Future<void> _pickPhoto() async {
    final XFile? img = await _imgPicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (img != null) setState(() => _photo = File(img.path));
  }

  // 根据标签选择不同文件列表
  Future<void> _pickFileByLabel(String label) async {
    List<File> target;
    if (label == 'Blood Test')
      target = _bloodReports;
    else if (label == 'Urine Test')
      target = _urineReports;
    else if (label == 'History Docs')
      target = _historyDocs;
    else
      return;
    final res = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (res != null) {
      setState(
        () => target.addAll(res.paths.whereType<String>().map((p) => File(p))),
      );
    }
  }

  // 保存资料
  void _saveProfile() {
    if (_infoKey.currentState!.validate()) {
      // TODO: 接入持久化逻辑
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile saved')));
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _contactCtrl.dispose();
    _emailCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Profile'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _sectionTitle('Basic Information'),
            Form(
              key: _infoKey,
              child: Column(
                children: [
                  _buildTextField('Name', _nameCtrl),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField('Age', _ageCtrl, number: true),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _buildGenderDropdown()),
                    ],
                  ),
                  _buildTextField('Contact No.', _contactCtrl, number: true),
                  _buildTextField('Email', _emailCtrl, email: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Medical Notes & Photo'),
            Form(
              key: _dataKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _notesCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Medical History / Notes',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  _uploadRow(
                    'Profile Photo',
                    onCamera: _pickPhoto,
                    onFile: () => _pickFileByLabel('Profile Photo'),
                    files: _photo != null ? [_photo!] : [],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Lab Reports Upload'),
            _reportSection('Blood Test', _bloodReports),
            _reportSection('Urine Test', _urineReports),
            _reportSection('History Docs', _historyDocs),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: _saveProfile,
              child: const Text('Save Profile', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController ctrl, {
    bool number = false,
    bool email = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType:
            number
                ? TextInputType.number
                : (email ? TextInputType.emailAddress : TextInputType.text),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (v) => v!.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _gender,
      decoration: const InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      items:
          const [
            'Male',
            'Female',
            'Other',
          ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
      onChanged: (v) => setState(() => _gender = v!),
    );
  }

  Widget _uploadRow(
    String label, {
    required VoidCallback onCamera,
    required VoidCallback onFile,
    required List<File> files,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          IconButton(onPressed: onCamera, icon: const Icon(Icons.camera_alt)),
          IconButton(onPressed: onFile, icon: const Icon(Icons.upload_file)),
          if (files.isNotEmpty)
            ...files.map(
              (f) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      label == 'Profile Photo'
                          ? Image.file(
                            f,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                          : const Icon(
                            Icons.insert_drive_file,
                            color: Colors.deepPurple,
                          ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _reportSection(String title, List<File> list) {
    return Column(
      children: [
        _uploadRow(
          title,
          onCamera: () {}, // 摄像不可用
          onFile: () => _pickFileByLabel(title),
          files: list,
        ),
      ],
    );
  }
}
