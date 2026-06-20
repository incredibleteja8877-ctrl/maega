import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/section_app_bar.dart';

/// Saved Addresses screen — add-new row plus saved address cards.
class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: backAppBar('Saved Addresses'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        children: const [
          _AddNewAddress(),
          SizedBox(height: 16),
          _AddressCard(
            icon: Icons.home_outlined,
            title: 'Home',
            address: '123, MG Road, Sector 12, Koramangala, Bangalore...',
            landmark: 'Near Apollo Hospital',
          ),
          SizedBox(height: 14),
          _AddressCard(
            icon: Icons.apartment,
            title: 'Office',
            address: '123, MG Road, Sector 12, Koramangala, Bangalore...',
            landmark: 'Near Apollo Hospital',
          ),
        ],
      ),
    );
  }
}

/// Bordered "Add New Address" row with a red filled plus box.
class _AddNewAddress extends StatelessWidget {
  const _AddNewAddress();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kRed),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: kRed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Text(
            'Add New Address',
            style: TextStyle(
              color: kRed,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

/// A saved-address card: icon + title, address, landmark, and edit/delete
/// action buttons on the right.
class _AddressCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String address;
  final String landmark;

  const _AddressCard({
    required this.icon,
    required this.title,
    required this.address,
    required this.landmark,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: kRed, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: const TextStyle(
                        color: kRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  address,
                  style: const TextStyle(color: kTextGrey, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: kTextGrey, size: 15),
                    const SizedBox(width: 4),
                    Text(
                      landmark,
                      style: const TextStyle(color: kTextGrey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: const [
              _SquareIcon(
                icon: Icons.edit_outlined,
                bg: Color(0xFFF0F0F0),
                fg: kIconDark,
              ),
              SizedBox(height: 10),
              _SquareIcon(
                icon: Icons.delete_outline,
                bg: Color(0xFFFBE3E8),
                fg: kRed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SquareIcon extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;
  const _SquareIcon({required this.icon, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: fg),
    );
  }
}
