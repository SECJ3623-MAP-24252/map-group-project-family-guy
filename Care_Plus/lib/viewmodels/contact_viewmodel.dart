import 'package:flutter/foundation.dart';
import '../models/contact_model.dart';
import '../services/contact_service.dart';

class ContactViewModel extends ChangeNotifier {
  final ContactService _contactService = ContactService();

  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';

  // Getters
  List<Contact> get contacts => _filteredContacts;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;

  // Initialize and load contacts
  Future<void> initialize() async {
    await loadContacts();
  }

  // Load all contacts
  Future<void> loadContacts() async {
    _setLoading(true);
    _clearError();

    try {
      _contacts = await _contactService.getAllContacts();
      _filterContacts();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Add new contact
  Future<bool> addContact({
    required String name,
    required String phoneNumber,
    required String email,
    String? imagePath,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final contact = Contact(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        phoneNumber: phoneNumber,
        email: email,
        imagePath: imagePath,
        createdAt: DateTime.now(),
      );

      await _contactService.addContact(contact);
      await loadContacts(); // Refresh the list
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update contact
  Future<bool> updateContact({
    required String id,
    required String name,
    required String phoneNumber,
    required String email,
    String? imagePath,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final existingContact = _contacts.firstWhere((c) => c.id == id);
      final updatedContact = existingContact.copyWith(
        name: name,
        phoneNumber: phoneNumber,
        email: email,
        imagePath: imagePath,
      );

      await _contactService.updateContact(updatedContact);
      await loadContacts(); // Refresh the list
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete contact
  Future<bool> deleteContact(String contactId) async {
    _setLoading(true);
    _clearError();

    try {
      await _contactService.deleteContact(contactId);
      await loadContacts(); // Refresh the list
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Search contacts
  void searchContacts(String query) {
    _searchQuery = query;
    _filterContacts();
  }

  // Filter contacts based on search query
  void _filterContacts() {
    if (_searchQuery.isEmpty) {
      _filteredContacts = List.from(_contacts);
    } else {
      _filteredContacts =
          _contacts.where((contact) {
            return contact.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                contact.phoneNumber.contains(_searchQuery) ||
                contact.email.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
          }).toList();
    }
    notifyListeners();
  }

  // Get contact by ID
  Contact? getContactById(String id) {
    try {
      return _contacts.firstWhere((contact) => contact.id == id);
    } catch (e) {
      return null;
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = '';
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _filterContacts();
  }

  // Refresh contacts
  Future<void> refresh() async {
    await loadContacts();
  }
}
