import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants.dart';
import '../data/app_data.dart';
import '../widgets/section_app_bar.dart';

const _countryCodes = [
  '+91',  // India
  '+1',   // USA / Canada
  '+44',  // UK
  '+61',  // Australia
  '+971', // UAE
  '+65',  // Singapore
  '+60',  // Malaysia
  '+49',  // Germany
  '+33',  // France
  '+81',  // Japan
  '+86',  // China
  '+7',   // Russia
  '+55',  // Brazil
  '+27',  // South Africa
  '+234', // Nigeria
];


/// Personal Information screen — Name, Phone and Email, each editable via the
/// red EDIT action. Values are stored in Hive and reflect on the Profile
/// screen instantly.
class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: backAppBar('Personal Information'),
      body: ValueListenableBuilder(
        valueListenable: profileBox.listenable(),
        builder: (context, Box box, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            children: [
              _InfoField(
                label: 'Name',
                value: box.get('name', defaultValue: '') as String,
                onEdit: () => _editField(
                  context,
                  key: 'name',
                  label: 'Name',
                  current: box.get('name', defaultValue: '') as String,
                ),
              ),
              const SizedBox(height: 18),
              _InfoField(
                label: 'Phone',
                value: box.get('phone', defaultValue: '') as String,
                keyboard: TextInputType.phone,
                onEdit: () => _editPhoneField(
                  context,
                  box.get('phone', defaultValue: '') as String,
                ),
              ),
              const SizedBox(height: 18),
              _InfoField(
                label: 'Email',
                value: box.get('email', defaultValue: '') as String,
                keyboard: TextInputType.emailAddress,
                onEdit: () => _editField(
                  context,
                  key: 'email',
                  label: 'Email',
                  current: box.get('email', defaultValue: '') as String,
                  keyboard: TextInputType.emailAddress,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _editPhoneField(BuildContext context, String current) async {
    String selectedCode = '+91';
    String numberPart = current;

    for (final code in _countryCodes) {
      if (current.startsWith(code)) {
        selectedCode = code;
        numberPart = current.substring(code.length).trim();
        break;
      }
    }

    final controller = TextEditingController(text: numberPart);

    final newValue = await showDialog<String>(
      context: context,
      builder: (context) {
        String picked = selectedCode;
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              title: const Text('Edit Phone'),
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    value: picked,
                    underline: const SizedBox(),
                    items: _countryCodes
                        .map((code) => DropdownMenuItem(
                              value: code,
                              child: Text(
                                code,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setLocal(() => picked = val);
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.phone,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Number',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kRed),
                        ),
                      ),
                    ),
                  ),
                ],
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
                  onPressed: () => Navigator.pop(
                    context,
                    '$picked ${controller.text.trim()}',
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (newValue != null && newValue.trim().isNotEmpty) {
      await profileBox.put('phone', newValue.trim());
    }
  }

  Future<void> _editField(
    BuildContext context, {
    required String key,
    required String label,
    required String current,
    TextInputType keyboard = TextInputType.text,
  }) async {
    final controller = TextEditingController(text: current);
    final newValue = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $label'),
          content: TextField(
            controller: controller,
            keyboardType: keyboard,
            autofocus: true,
            decoration: InputDecoration(
              labelText: label,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kRed),
              ),
            ),
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
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newValue != null && newValue.isNotEmpty) {
      await profileBox.put(key, newValue);
    }
  }
}

/// A labelled field row: small grey label above a bordered box that holds
/// the value on the left and a red EDIT button on the right.
class _InfoField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEdit;
  final TextInputType keyboard;

  const _InfoField({
    required this.label,
    required this.value,
    required this.onEdit,
    this.keyboard = TextInputType.text,
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
