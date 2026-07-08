import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _profileKey = 'profile';
const String _addressesKey = 'addresses';
const String _usersKey = 'users';

late SharedPreferences _prefs;

/// Reactive profile data — replaces the old Hive `profileBox.listenable()`.
final ValueNotifier<Map<String, dynamic>> profileNotifier =
    ValueNotifier<Map<String, dynamic>>({});

/// Reactive addresses list — replaces the old Hive `addressBox.listenable()`.
/// Each entry carries an explicit int `id` (Hive used to auto-generate this
/// as the box key).
final ValueNotifier<List<Map<String, dynamic>>> addressesNotifier =
    ValueNotifier<List<Map<String, dynamic>>>([]);

Map<String, dynamic> _decodeMap(String? raw) =>
    raw == null ? {} : Map<String, dynamic>.from(jsonDecode(raw) as Map);

List<Map<String, dynamic>> _decodeList(String? raw) {
  if (raw == null) return [];
  final list = jsonDecode(raw) as List;
  return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
}

Future<void> _saveProfile() =>
    _prefs.setString(_profileKey, jsonEncode(profileNotifier.value));

Future<void> _saveAddresses() =>
    _prefs.setString(_addressesKey, jsonEncode(addressesNotifier.value));

/// Initialize shared_preferences and seed default data on first launch.
Future<void> initAppData() async {
  _prefs = await SharedPreferences.getInstance();

  profileNotifier.value = _decodeMap(_prefs.getString(_profileKey));
  addressesNotifier.value = _decodeList(_prefs.getString(_addressesKey));

  if (profileNotifier.value.isEmpty) {
    profileNotifier.value = {
      'name': 'Jhon Doe',
      'phone': '+91 9876543210',
      'email': 'you@example.com',
      'avatarAsset': 'assets/images/Passport size photo.jpeg',
    };
    await _saveProfile();
  } else if (!profileNotifier.value.containsKey('avatarAsset')) {
    profileNotifier.value = {
      ...profileNotifier.value,
      'avatarAsset': 'assets/images/Passport size photo.jpeg',
    };
    await _saveProfile();
  }

  if (addressesNotifier.value.isEmpty) {
    addressesNotifier.value = [
      {
        'id': 1,
        'type': 'home',
        'title': 'Home',
        'address': '123, MG Road, Sector 12, Koramangala, Bangalore...',
        'landmark': 'Near Apollo Hospital',
      },
      {
        'id': 2,
        'type': 'office',
        'title': 'Office',
        'address': '123, MG Road, Sector 12, Koramangala, Bangalore...',
        'landmark': 'Near Apollo Hospital',
      },
    ];
    await _saveAddresses();
  }
}

// ---- Profile helpers ----

/// Sets a single profile field and persists it.
Future<void> putProfileValue(String key, dynamic value) async {
  profileNotifier.value = {...profileNotifier.value, key: value};
  await _saveProfile();
}

/// Merges the given fields into the profile and persists it.
Future<void> putAllProfileValues(Map<String, dynamic> values) async {
  profileNotifier.value = {...profileNotifier.value, ...values};
  await _saveProfile();
}

// ---- Address helpers ----

int _nextAddressId() {
  if (addressesNotifier.value.isEmpty) return 1;
  return addressesNotifier.value
          .map((e) => e['id'] as int)
          .reduce((a, b) => a > b ? a : b) +
      1;
}

Map<String, dynamic>? getAddress(int id) {
  for (final entry in addressesNotifier.value) {
    if (entry['id'] == id) return entry;
  }
  return null;
}

Future<void> addAddress(Map<String, dynamic> data) async {
  final entry = {'id': _nextAddressId(), ...data};
  addressesNotifier.value = [...addressesNotifier.value, entry];
  await _saveAddresses();
}

Future<void> updateAddress(int id, Map<String, dynamic> data) async {
  addressesNotifier.value = [
    for (final entry in addressesNotifier.value)
      if (entry['id'] == id) {'id': id, ...data} else entry,
  ];
  await _saveAddresses();
}

Future<void> deleteAddress(int id) async {
  addressesNotifier.value =
      addressesNotifier.value.where((entry) => entry['id'] != id).toList();
  await _saveAddresses();
}

// ---- Users helpers ----

Map<String, dynamic> _getUsers() => _decodeMap(_prefs.getString(_usersKey));

Future<void> _saveUsers(Map<String, dynamic> users) =>
    _prefs.setString(_usersKey, jsonEncode(users));

bool userExists(String email) => _getUsers().containsKey(email.toLowerCase());

Map<String, dynamic>? getUser(String email) {
  final data = _getUsers()[email.toLowerCase()];
  return data == null ? null : Map<String, dynamic>.from(data as Map);
}

Future<void> putUser(String email, Map<String, dynamic> data) async {
  final users = _getUsers();
  users[email.toLowerCase()] = data;
  await _saveUsers(users);
}
