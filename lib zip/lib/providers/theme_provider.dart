import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _themeModeKey = 'theme_mode';

/// Holds the reactive theme mode, persisted via shared_preferences.
/// Registered at the app root with ChangeNotifierProvider and read/watched
/// from screens with Provider.
class ThemeProvider extends ChangeNotifier {
  late SharedPreferences _prefs;

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Loads the persisted theme mode. Must be awaited once before the
  /// provider is used.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final saved = _prefs.getString(_themeModeKey);
    _themeMode = saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _prefs.setString(_themeModeKey, mode == ThemeMode.dark ? 'dark' : 'light');
  }

  Future<void> toggleTheme() =>
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
}
