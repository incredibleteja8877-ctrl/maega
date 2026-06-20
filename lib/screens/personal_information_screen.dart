import 'package:flutter/material.dart';
import '../constants.dart';

/// Personal Information screen — matches the assignment screenshot.
/// Shows Name, Phone and Email, each with a red EDIT action.
class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kTextDark,
        elevation: 0,
        titleSpacing: 0,
        title: const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kTextDark,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: kDivider),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        children: [
          _InfoField(
            label: 'Name',
            value: 'Jhon Doe',
            onEdit: () => _editTapped(context, 'Name'),
          ),
          const SizedBox(height: 18),
          _InfoField(
            label: 'Phone',
            value: '+91 9876543210',
            onEdit: () => _editTapped(context, 'Phone'),
          ),
          const SizedBox(height: 18),
          _InfoField(
            label: 'Email',
            value: 'you@example.com',
            onEdit: () => _editTapped(context, 'Email'),
          ),
        ],
      ),
    );
  }

  void _editTapped(BuildContext context, String field) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit $field')),
    );
  }
}

/// A labelled field row: small grey label above a bordered box that holds
/// the value on the left and a red EDIT button on the right.
class _InfoField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEdit;

  const _InfoField({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: kTextGrey),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kDivider),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: kTextDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                child: const Text(
                  'EDIT',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: kRed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
