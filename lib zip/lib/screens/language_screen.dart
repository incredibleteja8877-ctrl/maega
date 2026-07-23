import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/section_app_bar.dart';

const Color _blueBg = Color(0xFFEAF2FE);
const Color _blue = Color(0xFF2C5FBF);

/// A selectable language entry.
class _Language {
  final String name;
  final String native;
  const _Language(this.name, this.native);
}

const List<_Language> _languages = [
  _Language('English', 'English'),
  _Language('Hindi', 'हिन्दी'),
  _Language('Tamil', 'தமிழ்'),
  _Language('Telugu', 'తెలుగు'),
  _Language('Kannada', 'ಕನ್ನಡ'),
  _Language('Malayalam', 'മലയാളം'),
];

/// Language screen — info banner + selectable language list.
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int _selected = 0; // English by default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: backAppBar('Language'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        children: [
          _infoBanner(),
          const SizedBox(height: 16),
          for (int i = 0; i < _languages.length; i++) ...[
            _languageCard(_languages[i], i == _selected, () {
              setState(() => _selected = i);
            }),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _infoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _blueBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.language, color: _blue, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Your Language',
                  style: TextStyle(
                    color: _blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Select your preferred language for the app interface',
                  style: TextStyle(color: _blue, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageCard(_Language lang, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? kRed : kDivider),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lang.native,
                    style: const TextStyle(fontSize: 14, color: kTextGrey),
                  ),
                ],
              ),
            ),
            if (selected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: kRed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}
