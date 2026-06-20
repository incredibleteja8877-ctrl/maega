import 'package:hive_flutter/hive_flutter.dart';

/// Hive box names.
const String profileBoxName = 'profile';
const String addressBoxName = 'addresses';

/// Convenience accessors for the open boxes.
Box get profileBox => Hive.box(profileBoxName);
Box get addressBox => Hive.box(addressBoxName);

/// Initialize Hive, open boxes and seed default data on first launch.
Future<void> initAppData() async {
  await Hive.initFlutter();
  final profile = await Hive.openBox(profileBoxName);
  final addresses = await Hive.openBox(addressBoxName);

  if (profile.isEmpty) {
    await profile.putAll({
      'name': 'Jhon Doe',
      'phone': '+91 9876543210',
      'email': 'you@example.com',
    });
  }

  if (addresses.isEmpty) {
    await addresses.add({
      'type': 'home',
      'title': 'Home',
      'address': '123, MG Road, Sector 12, Koramangala, Bangalore...',
      'landmark': 'Near Apollo Hospital',
    });
    await addresses.add({
      'type': 'office',
      'title': 'Office',
      'address': '123, MG Road, Sector 12, Koramangala, Bangalore...',
      'landmark': 'Near Apollo Hospital',
    });
  }
}
