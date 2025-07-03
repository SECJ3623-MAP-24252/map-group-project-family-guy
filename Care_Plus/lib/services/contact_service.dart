import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/contact_model.dart';

class ContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Get contacts collection reference for current user
  CollectionReference get _contactsCollection =>
      _firestore.collection('users').doc(currentUserId).collection('contacts');

  // Add new contact
  Future<void> addContact(Contact contact) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    try {
      await _contactsCollection.doc(contact.id).set(contact.toMap());
    } catch (e) {
      throw Exception('Failed to add contact: $e');
    }
  }

  // Update existing contact
  Future<void> updateContact(Contact contact) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    try {
      await _contactsCollection.doc(contact.id).update(contact.toMap());
    } catch (e) {
      throw Exception('Failed to update contact: $e');
    }
  }

  // Delete contact
  Future<void> deleteContact(String contactId) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    try {
      await _contactsCollection.doc(contactId).delete();
    } catch (e) {
      throw Exception('Failed to delete contact: $e');
    }
  }

  // Get single contact
  Future<Contact?> getContact(String contactId) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    try {
      DocumentSnapshot doc = await _contactsCollection.doc(contactId).get();
      if (doc.exists) {
        return Contact.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get contact: $e');
    }
  }

  // Get all contacts as stream
  Stream<List<Contact>> getContactsStream() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _contactsCollection.orderBy('name').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Contact.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get all contacts as future
  Future<List<Contact>> getAllContacts() async {
    if (currentUserId == null) throw Exception('User not authenticated');

    try {
      QuerySnapshot snapshot = await _contactsCollection.orderBy('name').get();
      return snapshot.docs.map((doc) {
        return Contact.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get contacts: $e');
    }
  }

  // Search contacts by name
  Future<List<Contact>> searchContacts(String query) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    try {
      QuerySnapshot snapshot =
          await _contactsCollection
              .where('name', isGreaterThanOrEqualTo: query)
              .where('name', isLessThan: query + 'z')
              .get();

      return snapshot.docs.map((doc) {
        return Contact.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search contacts: $e');
    }
  }
}
