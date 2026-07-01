import 'package:flutter/material.dart';

class MaegaLogo extends StatelessWidget {
  const MaegaLogo({super.key, this.width, this.height = 100});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/maega_logo.png',
      width: width,
      height: height,
    );
  }
}
