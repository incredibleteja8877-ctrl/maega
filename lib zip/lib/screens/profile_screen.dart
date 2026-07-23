import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/app_data_provider.dart';
import '../widgets/maega_logo.dart';
import '../widgets/main_bottom_nav.dart';
import 'auth_gate.dart';
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

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    await context.read<AppDataProvider>().clear();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthGate()),
      (route) => false,
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all your data. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: kTextGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;

    final appData = context.read<AppDataProvider>();
    try {
      await _performDelete(appData);
    } on FirebaseAuthException catch (e) {
      if (e.code != 'requires-recent-login') {
        if (context.mounted) _showError(context, e.message ?? 'Failed to delete account.');
        return;
      }
      if (!context.mounted) return;
      final reauthed = await _reauthenticate(context);
      if (!reauthed) return;
      try {
        await _performDelete(appData);
      } catch (e2) {
        if (context.mounted) _showError(context, 'Failed to delete account: $e2');
        return;
      }
    } catch (e) {
      if (context.mounted) _showError(context, 'Failed to delete account: $e');
      return;
    }

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
        (route) => false,
      );
    }
  }

  Future<void> _performDelete(AppDataProvider appData) async {
    await appData.deleteAllData();
    await FirebaseAuth.instance.currentUser?.delete();
    await appData.clear();
  }

  /// Prompts for the account password and re-authenticates, as Firebase
  /// requires a recent sign-in before allowing account deletion.
  Future<bool> _reauthenticate(BuildContext context) async {
    final controller = TextEditingController();
    final password = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm your password'),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: kTextGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (password == null || password.isEmpty) return false;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return false;
    try {
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: user.email!, password: password),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) _showError(context, e.message ?? 'Re-authentication failed.');
      return false;
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: kRed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const MainBottomNav(currentIndex: 3),
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
                onTap: () => _deleteAccount(context),
              ),

              const SizedBox(height: 12),
              _logoutButton(context),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Maega V1.0',
                  style: GoogleFonts.poppins(color: kTextGrey, fontSize: 13),
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              'Profile',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kTextDark,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MaegaLogo(),
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
        ],
      ),
    );
  }

  // ---- Avatar + name + phone ----
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer<AppDataProvider>(
        builder: (context, appData, _) {
          final profile = appData.profile;
          final avatarAsset = profile['avatarAsset'] as String? ?? '';
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
                    profile['name'] as String? ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    profile['phone'] as String? ?? '',
                    style: GoogleFonts.poppins(fontSize: 13, color: kTextGrey),
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
              style: GoogleFonts.poppins(
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
