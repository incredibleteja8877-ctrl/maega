import 'package:hive_flutter/hive_flutter.dart';

/// Hive box names.
const String profileBoxName = 'profile';
const String addressBoxName = 'addresses';
const String usersBoxName = 'users';

/// Convenience accessors for the open boxes.
Box get profileBox => Hive.box(profileBoxName);
Box get addressBox => Hive.box(addressBoxName);
Box get usersBox => Hive.box(usersBoxName);

/// Initialize Hive, open boxes and seed default data on first launch.
Future<void> initAppData() async {
  await Hive.initFlutter();
  final profile = await Hive.openBox(profileBoxName);
  final addresses = await Hive.openBox(addressBoxName);
  await Hive.openBox(usersBoxName);

  if (profile.isEmpty) {
    await profile.putAll({
      'name': 'Jhon Doe',
      'phone': '+91 9876543210',
      'email': 'you@example.com',
      'avatarAsset': 'assets/images/Passport size photo.jpeg',
    });
  } else if (!profile.containsKey('avatarAsset')) {
    await profile.put('avatarAsset', 'assets/images/Passport size photo.jpeg');
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
