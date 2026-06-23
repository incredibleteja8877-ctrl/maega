import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/section_app_bar.dart';

/// Help And Support screen — "All Topics" list with chevrons.
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: backAppBar('Help And Support'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        children: const [
          Text(
            'All Topics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kTextDark,
            ),
          ),
          SizedBox(height: 6),
          _TopicRow(icon: Icons.person_outline, label: 'Account'),
          _TopicRow(
              icon: Icons.person_outline, label: 'Getting Started With Maega'),
          _TopicRow(
              icon: Icons.credit_card, label: 'Payment & Maega Credits'),
          _TopicRow(
              icon: Icons.desktop_windows_outlined,
              label: 'Maega Plus Membership'),
          _TopicRow(icon: Icons.verified_user_outlined, label: 'Maega Safety'),
          _TopicRow(icon: Icons.check_circle_outline, label: 'Claim Warranty'),
        ],
      ),
    );
  }
}

class _TopicRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TopicRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: kIconDark, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: kTextDark,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: kTextGrey, size: 22),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: kDivider),
      ],
    );
  }
}
