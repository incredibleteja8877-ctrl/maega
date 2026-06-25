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
        children: [
          const Text(
            'All Topics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kTextDark,
            ),
          ),
          const SizedBox(height: 6),
          _TopicRow(icon: const Icon(Icons.person_outline, color: kIconDark, size: 22), label: 'Account'),
          _TopicRow(icon: const Icon(Icons.person_outline, color: kIconDark, size: 22), label: 'Getting Started With Maega'),
          _TopicRow(
            icon: Image.asset('assets/images/payment & maega credits.png', width: 22, height: 22),
            label: 'Payment & Maega Credits',
          ),
          _TopicRow(
            icon: Image.asset('assets/images/Maega plus.png', width: 22, height: 22),
            label: 'Maega Plus Membership',
          ),
          _TopicRow(icon: const Icon(Icons.verified_user_outlined, color: kIconDark, size: 22), label: 'Maega Safety'),
          _TopicRow(
            icon: Image.asset('assets/images/claim warranty.png', width: 22, height: 22),
            label: 'Claim Warranty',
          ),
        ],
      ),
    );
  }
}

class _TopicRow extends StatelessWidget {
  final Widget icon;
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
              icon,
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
