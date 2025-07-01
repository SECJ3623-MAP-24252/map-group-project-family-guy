import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineViewModel with ChangeNotifier {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('medicines');

  /// Stream realtime dari koleksi 'medicines'
  Stream<QuerySnapshot> get medicinesStream {
    return _collection.orderBy('createdAt', descending: true).snapshots();
  }

  /// Fungsi hapus medicine by docId
  Future<void> deleteMedicine(String docId) async {
    try {
      await _collection.doc(docId).delete();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting medicine: $e');
    }
  }
}
  