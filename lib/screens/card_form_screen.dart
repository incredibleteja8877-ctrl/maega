import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/app_data_provider.dart';
import '../widgets/section_app_bar.dart';

/// Add a new saved card. Only the card brand, last 4 digits, expiry and
/// holder name are persisted — the full card number and CVV are used
/// locally to validate the card and are never stored or sent anywhere.
class CardFormScreen extends StatefulWidget {
  const CardFormScreen({super.key});

  @override
  State<CardFormScreen> createState() => _CardFormScreenState();
}

class _CardFormScreenState extends State<CardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _holderCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _holderCtrl.dispose();
    _numberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  String get _digitsOnly => _numberCtrl.text.replaceAll(' ', '');

  String _detectBrand(String digits) {
    if (digits.startsWith('4')) return 'Visa';
    final firstTwo = digits.length >= 2 ? int.tryParse(digits.substring(0, 2)) : null;
    final firstFour = digits.length >= 4 ? int.tryParse(digits.substring(0, 4)) : null;
    if (firstTwo != null && firstTwo >= 51 && firstTwo <= 55) return 'Mastercard';
    if (firstFour != null && firstFour >= 2221 && firstFour <= 2720) return 'Mastercard';
    if (firstTwo == 60 || firstTwo == 65 || firstTwo == 81 || firstTwo == 82) return 'RuPay';
    return 'Card';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);
    final digits = _digitsOnly;
    final data = {
      'holderName': _holderCtrl.text.trim(),
      'brand': _detectBrand(digits),
      'last4': digits.substring(digits.length - 4),
      'expiry': _expiryCtrl.text.trim(),
    };
    try {
      await context.read<AppDataProvider>().addCard(data);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: backAppBar('Add New Card'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          children: [
            _label('Cardholder Name'),
            TextFormField(
              controller: _holderCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: _decoration('Name on card'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter the cardholder name' : null,
            ),
            const SizedBox(height: 18),
            _label('Card Number'),
            TextFormField(
              controller: _numberCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                _CardNumberFormatter(),
              ],
              decoration: _decoration('1234 5678 9012 3456'),
              validator: (v) {
                final digits = (v ?? '').replaceAll(' ', '');
                if (digits.length != 16) return 'Enter a valid 16-digit card number';
                return null;
              },
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Expiry (MM/YY)'),
                      TextFormField(
                        controller: _expiryCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          _ExpiryFormatter(),
                        ],
                        decoration: _decoration('MM/YY'),
                        validator: _validateExpiry,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('CVV'),
                      TextFormField(
                        controller: _cvvCtrl,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: _decoration('CVV'),
                        validator: (v) => (v == null || v.length < 3)
                            ? 'Enter a valid CVV'
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text(
                        'Save Card',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateExpiry(String? v) {
    final text = v ?? '';
    final match = RegExp(r'^(\d{2})/(\d{2})$').firstMatch(text);
    if (match == null) return 'Enter expiry as MM/YY';
    final month = int.parse(match.group(1)!);
    final year = 2000 + int.parse(match.group(2)!);
    if (month < 1 || month > 12) return 'Enter a valid month';
    final now = DateTime.now();
    final expiryEnd = DateTime(year, month + 1);
    if (expiryEnd.isBefore(now)) return 'This card has expired';
    return null;
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

/// Inserts a space after every 4 digits: 1234 5678 9012 3456.
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

/// Inserts a slash after the first 2 digits: MM/YY.
class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
