import 'package:flutter/material.dart';
import '../constants.dart';

/// Temporary screen used for menu items we haven't built yet.
/// Replace each one with a real screen as the screenshots come in.
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kTextDark,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: kTextDark,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction, size: 56, color: kTextGrey),
            const SizedBox(height: 12),
            Text(
              '$title screen coming soon',
              style: const TextStyle(color: kTextGrey, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
