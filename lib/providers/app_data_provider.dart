import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Holds the reactive profile and saved-addresses state, synced live with
/// Cloud Firestore (`users/{uid}` doc + `users/{uid}/addresses` subcollection).
/// Registered once at the app root with ChangeNotifierProvider and
/// read/watched from screens with Provider.
class AppDataProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  String? _uid;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _profileSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _addressesSub;

  Map<String, dynamic> _profile = {};
  List<Map<String, dynamic>> _addresses = [];

  Map<String, dynamic> get profile => _profile;
  List<Map<String, dynamic>> get addresses => _addresses;

  DocumentReference<Map<String, dynamic>> get _userDoc =>
      _firestore.collection('users').doc(_uid);

  /// Attaches live listeners for the given user's profile and addresses.
  /// Call once after sign-in; call [clear] on sign-out.
  Future<void> loadForUser(String uid) async {
    if (_uid == uid) return;
    await clear();
    _uid = uid;

    _profileSub = _userDoc.snapshots().listen((snapshot) {
      _profile = snapshot.data() ?? {};
      notifyListeners();
    });

    _addressesSub = _userDoc.collection('addresses').snapshots().listen((snapshot) {
      _addresses = snapshot.docs.map((doc) => doc.data()).toList()
        ..sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
      notifyListeners();
    });
  }

  /// Detaches listeners and resets state. Call on sign-out.
  Future<void> clear() async {
    await _profileSub?.cancel();
    await _addressesSub?.cancel();
    _profileSub = null;
    _addressesSub = null;
    _uid = null;
    _profile = {};
    _addresses = [];
    notifyListeners();
  }

  // ---- Profile ----

  /// Sets a single profile field and persists it.
  Future<void> putProfileValue(String key, dynamic value) =>
      _userDoc.set({key: value}, SetOptions(merge: true));

  /// Merges the given fields into the profile and persists it.
  Future<void> putAllProfileValues(Map<String, dynamic> values) =>
      _userDoc.set(values, SetOptions(merge: true));

  // ---- Addresses ----

  int _nextAddressId() {
    if (_addresses.isEmpty) return 1;
    return _addresses
            .map((e) => e['id'] as int)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  Map<String, dynamic>? getAddress(int id) {
    for (final entry in _addresses) {
      if (entry['id'] == id) return entry;
    }
    return null;
  }

  Future<void> addAddress(Map<String, dynamic> data) async {
    final id = _nextAddressId();
    final entry = {'id': id, ...data};
    await _userDoc.collection('addresses').doc(id.toString()).set(entry);
  }

  Future<void> updateAddress(int id, Map<String, dynamic> data) async {
    final entry = {'id': id, ...data};
    await _userDoc.collection('addresses').doc(id.toString()).set(entry);
  }

  Future<void> deleteAddress(int id) async {
    await _userDoc.collection('addresses').doc(id.toString()).delete();
  }

  // ---- Account deletion ----

  /// Deletes the profile doc and every saved address from Firestore. Does
  /// not touch the Firebase Auth account itself — call [clear] and
  /// `FirebaseAuth.instance.currentUser?.delete()` alongside this.
  Future<void> deleteAllData() async {
    final addressesSnap = await _userDoc.collection('addresses').get();
    final batch = _firestore.batch();
    for (final doc in addressesSnap.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_userDoc);
    await batch.commit();
  }

  @override
  void dispose() {
    _profileSub?.cancel();
    _addressesSub?.cancel();
    super.dispose();
  }
}
