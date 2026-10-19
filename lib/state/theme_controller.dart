import 'package:flutter/material.dart';

/// Owns the light/dark preference. Lives above [MaterialApp] so the choice
/// survives navigation, and is read by the theme switch in the app bar.
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  bool isDark(BuildContext context) {
    if (_mode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return _mode == ThemeMode.dark;
  }

  void toggle(BuildContext context) {
    _mode = isDark(context) ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
