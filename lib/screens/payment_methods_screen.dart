import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/app_data_provider.dart';
import '../widgets/section_app_bar.dart';
import 'card_form_screen.dart';

/// Payment Methods screen — Saved Cards, Wallets and UPI sections.
class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  void _addCard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CardFormScreen()),
    );
  }

  Future<void> _deleteCard(BuildContext context, int id, String label) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Card'),
        content: Text('Remove the $label card?'),
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
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      if (!context.mounted) return;
      await context.read<AppDataProvider>().deleteCard(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: backAppBar('Payment Methods'),
      body: Consumer<AppDataProvider>(
        builder: (context, appData, _) {
          final cards = appData.cards;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            children: [
              const _SectionLabel('SAVED CARDS', spaced: true),
              const SizedBox(height: 10),
              _AddNewCard(onTap: () => _addCard(context)),
              for (final data in cards) ...[
                const SizedBox(height: 12),
                Builder(builder: (context) {
                  final id = data['id'] as int;
                  final brand = (data['brand'] as String?) ?? 'Card';
                  final last4 = (data['last4'] as String?) ?? '••••';
                  return _SavedCard(
                    brand: brand,
                    last4: last4,
                    holderName: (data['holderName'] as String?) ?? '',
                    expiry: (data['expiry'] as String?) ?? '',
                    onDelete: () => _deleteCard(context, id, '$brand •••• $last4'),
                  );
                }),
              ],
              const SizedBox(height: 22),
              const _SectionLabel('Wallets'),
              const SizedBox(height: 10),
              const _AccountCard(names: ['Mobikwik', 'Phonepe', 'Amazon Pay']),
              const SizedBox(height: 24),
              const _UpiLabel(),
              const SizedBox(height: 10),
              const _AccountCard(names: ['Google Pay', 'Phonepe', 'Paytm']),
            ],
          );
        },
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
  final VoidCallback onTap;
  const _AddNewCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
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
      ),
    );
  }
}

/// A saved card: brand + masked number, holder name and expiry, with a
/// delete action on the right.
class _SavedCard extends StatelessWidget {
  final String brand;
  final String last4;
  final String holderName;
  final String expiry;
  final VoidCallback onDelete;

  const _SavedCard({
    required this.brand,
    required this.last4,
    required this.holderName,
    required this.expiry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kDivider),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kRed,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(Icons.credit_card, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$brand •••• $last4',
                  style: const TextStyle(
                    color: kTextDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$holderName · Exp $expiry',
                  style: const TextStyle(color: kTextGrey, fontSize: 12),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFFBE3E8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline, color: kRed, size: 18),
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
