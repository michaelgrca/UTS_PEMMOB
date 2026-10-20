import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Owns the light/dark preference. Lives above [MaterialApp] so the choice
/// survives navigation, and is persisted locally so the app opens with the
/// same appearance next time.
class ThemeController extends ChangeNotifier {
  ThemeController(this._preferences) : _mode = _readMode(_preferences);

  static const String storageKey = 'tunas.theme_mode.v1';

  final SharedPreferences _preferences;
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  bool isDark(BuildContext context) {
    if (_mode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return _mode == ThemeMode.dark;
  }

  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    await _preferences.setString(storageKey, _encode(mode));
  }

  Future<void> toggle(BuildContext context) {
    return setMode(isDark(context) ? ThemeMode.light : ThemeMode.dark);
  }

  static ThemeMode _readMode(SharedPreferences preferences) {
    return switch (preferences.getString(storageKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  static String _encode(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    ThemeMode.system => 'system',
  };
}
