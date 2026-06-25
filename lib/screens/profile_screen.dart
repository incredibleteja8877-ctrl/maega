import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants.dart';
import '../data/app_data.dart';
import '../widgets/maega_logo.dart';
import 'login_screen.dart';
import 'personal_information_screen.dart';
import 'payment_methods_screen.dart';
import 'saved_addresses_screen.dart';
import 'help_support_screen.dart';
import 'language_screen.dart';
import 'about_screen.dart';
import 'placeholder_screen.dart';

/// Profile screen — matches the assignment screenshot.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _open(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaceholderScreen(title: title)),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomNav(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(),
              const SizedBox(height: 8),
              _header(),
              const SizedBox(height: 16),
              const _ThinDivider(doubled: true),
              const SizedBox(height: 6),

              // Menu items
              _MenuItem(
                icon: const Icon(Icons.article_outlined, color: kIconDark, size: 23),
                label: 'Personal Information',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PersonalInformationScreen(),
                  ),
                ),
              ),
              _MenuItem(
                icon: Image.asset('assets/images/saved addresses.png', width: 23, height: 23),
                label: 'Saved Addresses',
                onTap: () => _push(context, const SavedAddressesScreen()),
              ),
              _MenuItem(
                icon: const Icon(Icons.credit_card, color: kIconDark, size: 23),
                label: 'Payment Methods',
                onTap: () => _push(context, const PaymentMethodsScreen()),
              ),
              _MenuItem(
                icon: Image.asset('assets/images/offers & rewards.png', width: 23, height: 23),
                label: 'Offers & Rewards',
                onTap: () => _open(context, 'Offers & Rewards'),
              ),
              _MenuItem(
                icon: Image.asset('assets/images/language.png', width: 23, height: 23),
                label: 'Language',
                onTap: () => _push(context, const LanguageScreen()),
              ),
              _MenuItem(
                icon: Image.asset('assets/images/help and support.png', width: 23, height: 23),
                label: 'Help And Support',
                onTap: () => _push(context, const HelpSupportScreen()),
              ),
              _MenuItem(
                icon: const Icon(Icons.info_outline, color: kIconDark, size: 23),
                label: 'About Maega',
                onTap: () => _push(context, const AboutScreen()),
              ),

              const SizedBox(height: 6),
              const _ThinDivider(),
              const SizedBox(height: 6),

              _MenuItem(
                icon: Image.asset('assets/images/delete-outline-rounded.png', width: 23, height: 23),
                label: 'Delete Account',
                color: kRed,
                onTap: () => _open(context, 'Delete Account'),
              ),

              const SizedBox(height: 12),
              _logoutButton(context),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Maega V1.0',
                  style: TextStyle(color: kTextGrey, fontSize: 13),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Top bar: logo • Profile • settings ----
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const MaegaLogo(),
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kTextDark,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kDivider),
            ),
            child: const Icon(Icons.settings, color: kIconDark, size: 20),
          ),
        ],
      ),
    );
  }

  // ---- Avatar + name + phone ----
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ValueListenableBuilder(
        valueListenable: profileBox.listenable(),
        builder: (context, Box box, _) {
          final avatarAsset = box.get('avatarAsset', defaultValue: '') as String;
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kRed,
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFEEEEEE),
                  backgroundImage:
                      avatarAsset.isNotEmpty ? AssetImage(avatarAsset) : null,
                  child: avatarAsset.isEmpty
                      ? const Icon(Icons.person, size: 32, color: kTextGrey)
                      : null,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    box.get('name', defaultValue: '') as String,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    box.get('phone', defaultValue: '') as String,
                    style: const TextStyle(fontSize: 13, color: kTextGrey),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // ---- Log Out filled button ----
  Widget _logoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () => _logout(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: kRed,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.logout, size: 20),
          label: const Text(
            'Log Out',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // ---- Bottom navigation ----
  Widget _bottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 3,
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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          label: 'Booking',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.storefront_outlined),
          label: 'Store',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}

/// A single tappable row in the profile menu.
class _MenuItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = kIconDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 18),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: color == kIconDark ? kTextDark : color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThinDivider extends StatelessWidget {
  final bool doubled;
  const _ThinDivider({this.doubled = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: doubled
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 1, color: kDivider),
                const SizedBox(height: 3),
                Container(height: 1, color: kDivider),
              ],
            )
          : Container(height: 1, color: kDivider),
    );
  }
}
