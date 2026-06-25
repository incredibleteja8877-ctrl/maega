import 'package:flutter/material.dart';
import '../constants.dart';

/// Shared app bar used by the inner screens: a back arrow, a bold left-aligned
/// title, and a thin divider underneath.
PreferredSizeWidget backAppBar(String title) {
  return AppBar(
    backgroundColor: Colors.white,
    foregroundColor: kTextDark,
    elevation: 0,
    titleSpacing: 0,
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: kTextDark,
      ),
    ),
    bottom: const PreferredSize(
      preferredSize: Size.fromHeight(1),
      child: Divider(height: 1, thickness: 1, color: kDivider),
    ),
  );
}
