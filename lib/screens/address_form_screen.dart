import 'package:flutter/material.dart';
import '../constants.dart';
import '../data/app_data.dart';
import '../widgets/section_app_bar.dart';

/// Add or edit a saved address. Pass [addressKey] (the Hive key) to edit an
/// existing one; leave it null to add a new address.
class AddressFormScreen extends StatefulWidget {
  final dynamic addressKey;
  const AddressFormScreen({super.key, this.addressKey});

  bool get isEditing => addressKey != null;

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _addressCtrl;
  late final TextEditingController _landmarkCtrl;
  String _type = 'home';

  static const _types = {
    'home': ['Home', Icons.home_outlined],
    'office': ['Office', Icons.apartment],
    'other': ['Other', Icons.location_on_outlined],
  };

  @override
  void initState() {
    super.initState();
    final existing = widget.isEditing
        ? Map<String, dynamic>.from(addressBox.get(widget.addressKey) as Map)
        : <String, dynamic>{};
    _type = (existing['type'] as String?) ?? 'home';
    _addressCtrl =
        TextEditingController(text: (existing['address'] as String?) ?? '');
    _landmarkCtrl =
        TextEditingController(text: (existing['landmark'] as String?) ?? '');
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _landmarkCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'type': _type,
      'title': (_types[_type]![0] as String),
      'address': _addressCtrl.text.trim(),
      'landmark': _landmarkCtrl.text.trim(),
    };
    if (widget.isEditing) {
      await addressBox.put(widget.addressKey, data);
    } else {
      await addressBox.add(data);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: backAppBar(widget.isEditing ? 'Edit Address' : 'Add New Address'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          children: [
            const Text('Type', style: TextStyle(color: kTextGrey)),
            const SizedBox(height: 8),
            Row(
              children: _types.entries.map((e) {
                final selected = _type == e.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(e.value[0] as String),
                    avatar: Icon(
                      e.value[1] as IconData,
                      size: 18,
                      color: selected ? Colors.white : kIconDark,
                    ),
                    selected: selected,
                    selectedColor: kRed,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : kTextDark,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() => _type = e.key),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _label('Address'),
            TextFormField(
              controller: _addressCtrl,
              maxLines: 2,
              decoration: _decoration('Full address'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter the address' : null,
            ),
            const SizedBox(height: 18),
            _label('Landmark'),
            TextFormField(
              controller: _landmarkCtrl,
              decoration: _decoration('Nearby landmark'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a landmark' : null,
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  widget.isEditing ? 'Update Address' : 'Save Address',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(color: kTextGrey)),
      );

  InputDecoration _decoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: kTextGrey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kRed, width: 1.5),
        ),
      );
}
