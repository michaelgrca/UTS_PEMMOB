import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunas_quiz/state/theme_controller.dart';

void main() {
  test('theme choice is restored from local storage', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    final controller = ThemeController(preferences);
    expect(controller.mode, ThemeMode.system);

    await controller.setMode(ThemeMode.dark);

    final restored = ThemeController(preferences);
    expect(restored.mode, ThemeMode.dark);
  });
}
