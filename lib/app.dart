import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'state/quiz_controller.dart';
import 'state/score_history_controller.dart';
import 'state/theme_controller.dart';

class TunasApp extends StatelessWidget {
  const TunasApp({super.key, required this.preferences});

  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController(preferences)),
        ChangeNotifierProvider(create: (_) => QuizController()),
        ChangeNotifierProvider(
          create: (_) => ScoreHistoryController(preferences)..load(),
        ),
      ],
      child: Consumer<ThemeController>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: 'Tunas — Kuis Alam Nusantara',
            debugShowCheckedModeBanner: false,
            themeMode: theme.mode,
            theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            themeAnimationDuration: const Duration(milliseconds: 260),
            themeAnimationCurve: Curves.easeOut,
            home: const HomeScreen(),
            builder: (context, child) {
              final brightness = switch (theme.mode) {
                ThemeMode.system =>
                  MediaQuery.platformBrightnessOf(context) == Brightness.dark
                      ? Brightness.dark
                      : Brightness.light,
                ThemeMode.dark => Brightness.dark,
                ThemeMode.light => Brightness.light,
              };
              return AnimatedTheme(
                data: TunasTheme.build(context, brightness),
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOut,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
