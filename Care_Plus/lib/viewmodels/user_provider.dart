import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String? _role;
  Map<String, dynamic>? _userData;
  bool _loading = false;

  String? get role => _role;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _loading;

  Future<void> loadUser() async {
    _loading = true;
    notifyListeners();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _role = null;
        _userData = null;
        _loading = false;
        notifyListeners();
        return;
      }
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        _userData = doc.data();
        _role = _userData?['role'] as String?;
      } else {
        _userData = null;
        _role = null;
      }
    } catch (e) {
      _userData = null;
      _role = null;
    }
    _loading = false;
    notifyListeners();
  }

  void clear() {
    _role = null;
    _userData = null;
    notifyListeners();
  }
} 