import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final CollectionReference _notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  Future<void> _addNote(String content) async {
    if (content.isEmpty) return;
    await _notes.add({
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _deleteNote(String id) async {
    await _notes.doc(id).delete();
  }

  void _showAddNoteSheet() {
    String newText = '';
    showCupertinoModalPopup(
      context: context,
      builder:
          (_) => CupertinoActionSheet(
            message: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoTextField(
                placeholder: 'New note',
                maxLines: null,
                onChanged: (v) => newText = v,
              ),
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  _addNote(newText);
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Notes')),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _notes.orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Notes',
                        style: TextStyle(
                          fontSize: 18,
                          color: CupertinoColors.inactiveGray,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final note = docs[index];
                      final content = note['content'] as String;
                      final timestamp = note['timestamp'] as Timestamp?;
                      final date = timestamp?.toDate() ?? DateTime.now();

                      return Dismissible(
                        key: Key(note.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => _deleteNote(note.id),
                        background: Container(
                          color: CupertinoColors.systemRed,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            CupertinoIcons.delete,
                            color: CupertinoColors.white,
                          ),
                        ),
                        // Wrap ListTile in Material so it has a proper ancestor
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            title: Text(
                              content,
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              '${date.year}-${date.month.toString().padLeft(2, '0')}-'
                              '${date.day.toString().padLeft(2, '0')} '
                              '${date.hour.toString().padLeft(2, '0')}:'
                              '${date.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoButton(
                color: CupertinoColors.activeBlue,
                child: const Text('New Note'),
                onPressed: _showAddNoteSheet,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
