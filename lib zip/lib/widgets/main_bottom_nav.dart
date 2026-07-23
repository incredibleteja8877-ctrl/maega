import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/home_screen.dart';
import '../screens/jobs_screen.dart';
import '../screens/earnings_screen.dart';
import '../screens/profile_screen.dart';

/// Bottom navigation bar shared by the 4 main tabs — Home, Jobs, Earnings,
/// Profile. Switches tabs with pushReplacement so the back stack doesn't grow.
class MainBottomNav extends StatelessWidget {
  final int currentIndex;
  const MainBottomNav({super.key, required this.currentIndex});

  static const _icons = [
    'assets/images/home nav.png',
    'assets/images/Jobs.png',
    'assets/images/Earnings.png',
    'assets/images/Profile.png',
  ];
  static const _labels = ['Home', 'Jobs', 'Earnings', 'Profile'];

  void _go(BuildContext context, int index) {
    if (index == currentIndex) return;
    final Widget page = switch (index) {
      0 => const HomeScreen(),
      1 => const JobsScreen(),
      2 => const EarningsScreen(),
      _ => const ProfileScreen(),
    };
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _go(context, index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: kRed,
      unselectedItemColor: kTextGrey,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      showUnselectedLabels: true,
      elevation: 8,
      items: [
        for (var i = 0; i < _labels.length; i++)
          BottomNavigationBarItem(
            icon: Image.asset(_icons[i], width: 24, height: 24),
            label: _labels[i],
          ),
      ],
    );
  }
}
