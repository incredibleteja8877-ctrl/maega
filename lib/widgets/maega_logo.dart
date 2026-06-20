import 'package:flutter/material.dart';
import '../constants.dart';

/// The small "MAEGA" brand mark shown in the app bar.
///
/// Approximates the logo with a red star + "MAEGA" wordmark. If you later add
/// the real logo image to assets/images, swap the build() body for an
/// Image.asset.
class MaegaLogo extends StatelessWidget {
  const MaegaLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.star, color: kRed, size: 26),
        SizedBox(height: 2),
        Text(
          'MAEGA',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: kTextDark,
          ),
        ),
      ],
    );
  }
}
