import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/section_app_bar.dart';

/// Payment Methods screen — Saved Cards, Wallets and UPI sections.
class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: backAppBar('Payment Methods'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        children: const [
          _SectionLabel('SAVED CARDS', spaced: true),
          SizedBox(height: 10),
          _AddNewCard(),
          SizedBox(height: 22),
          _SectionLabel('Wallets'),
          SizedBox(height: 10),
          _AccountCard(names: ['Mobikwik', 'Phonepe', 'Amazon Pay']),
          SizedBox(height: 24),
          _UpiLabel(),
          SizedBox(height: 10),
          _AccountCard(names: ['Google Pay', 'Phonepe', 'Paytm']),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final bool spaced;
  const _SectionLabel(this.text, {this.spaced = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: kTextGrey,
        fontWeight: FontWeight.w600,
        letterSpacing: spaced ? 1.0 : 0,
      ),
    );
  }
}

/// "UPI" label with a line extending to the right (as in the screenshot).
class _UpiLabel extends StatelessWidget {
  const _UpiLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text(
          'UPI',
          style: TextStyle(
            fontSize: 13,
            color: kTextGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 10),
        Expanded(child: Divider(thickness: 1, color: kDivider)),
      ],
    );
  }
}

/// Bordered "ADD NEW CARD" row with a red-outlined plus box.
class _AddNewCard extends StatelessWidget {
  const _AddNewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kDivider),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: kRed),
            ),
            child: const Icon(Icons.add, color: kRed, size: 18),
          ),
          const SizedBox(width: 12),
          const Text(
            'ADD NEW CARD',
            style: TextStyle(
              color: kRed,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// A bordered card listing accounts; each row shows the name and a red
/// "LINK ACCOUNT" action, separated by thin dividers.
class _AccountCard extends StatelessWidget {
  final List<String> names;
  const _AccountCard({required this.names});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kDivider),
      ),
      child: Column(
        children: [
          for (int i = 0; i < names.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    names[i],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                    ),
                  ),
                  const Text(
                    'LINK ACCOUNT',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: kRed,
                    ),
                  ),
                ],
              ),
            ),
            if (i != names.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                color: kDivider,
                indent: 14,
                endIndent: 14,
              ),
          ],
        ],
      ),
    );
  }
}
