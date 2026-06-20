import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants.dart';
import '../data/app_data.dart';
import '../widgets/section_app_bar.dart';
import 'address_form_screen.dart';

/// Saved Addresses screen — add, edit and delete addresses stored in Hive.
class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  static const _icons = {
    'home': Icons.home_outlined,
    'office': Icons.apartment,
    'other': Icons.location_on_outlined,
  };

  void _add(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddressFormScreen()),
    );
  }

  void _edit(BuildContext context, dynamic key) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddressFormScreen(addressKey: key)),
    );
  }

  Future<void> _delete(BuildContext context, dynamic key, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Delete the "$title" address?'),
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
    if (confirm == true) {
      await addressBox.delete(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: backAppBar('Saved Addresses'),
      body: ValueListenableBuilder(
        valueListenable: addressBox.listenable(),
        builder: (context, Box box, _) {
          final keys = box.keys.toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            children: [
              _AddNewAddress(onTap: () => _add(context)),
              const SizedBox(height: 16),
              if (keys.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      'No saved addresses yet',
                      style: TextStyle(color: kTextGrey),
                    ),
                  ),
                ),
              for (final key in keys) ...[
                Builder(builder: (context) {
                  final data = Map<String, dynamic>.from(box.get(key) as Map);
                  final type = (data['type'] as String?) ?? 'other';
                  return _AddressCard(
                    icon: _icons[type] ?? Icons.location_on_outlined,
                    title: (data['title'] as String?) ?? '',
                    address: (data['address'] as String?) ?? '',
                    landmark: (data['landmark'] as String?) ?? '',
                    onEdit: () => _edit(context, key),
                    onDelete: () =>
                        _delete(context, key, (data['title'] as String?) ?? ''),
                  );
                }),
                const SizedBox(height: 14),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Bordered "Add New Address" row with a red filled plus box.
class _AddNewAddress extends StatelessWidget {
  final VoidCallback onTap;
  const _AddNewAddress({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
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
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.icon,
    required this.title,
    required this.address,
    required this.landmark,
    required this.onEdit,
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
                    Expanded(
                      child: Text(
                        landmark,
                        style: const TextStyle(color: kTextGrey, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              _SquareIcon(
                icon: Icons.edit_outlined,
                bg: const Color(0xFFF0F0F0),
                fg: kIconDark,
                onTap: onEdit,
              ),
              const SizedBox(height: 10),
              _SquareIcon(
                icon: Icons.delete_outline,
                bg: const Color(0xFFFBE3E8),
                fg: kRed,
                onTap: onDelete,
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
  final VoidCallback onTap;
  const _SquareIcon({
    required this.icon,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: fg),
      ),
    );
  }
}
