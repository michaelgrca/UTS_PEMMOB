import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import 'app_colors.dart';

/// Builds the app theme for the current window size so typography scales with
/// the device. The theme is assembled inside [MaterialApp.builder] where the
/// real [MediaQuery] is available.
abstract final class TunasTheme {
  static ThemeData build(BuildContext context, Brightness brightness) {
    final palette = brightness == Brightness.light
        ? TunasPalette.light
        : TunasPalette.dark;
    final scale = context.typeScale;

    TextStyle display(double size, {double height = 1.02}) => TextStyle(
      fontFamily: 'Fraunces',
      fontSize: size * scale,
      height: height,
      fontWeight: FontWeight.w600,
      letterSpacing: -size * 0.022,
      color: palette.ink,
    );

    final textTheme = TextTheme(
      displayLarge: display(60, height: 0.98),
      displayMedium: display(46),
      displaySmall: display(38),
      headlineLarge: display(34, height: 1.08),
      headlineMedium: display(28, height: 1.12),
      headlineSmall: display(23, height: 1.15),
      titleLarge: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 20 * scale,
        height: 1.3,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: palette.ink,
      ),
      titleMedium: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 16 * scale,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: palette.ink,
      ),
      titleSmall: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 14 * scale,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: palette.ink,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 16 * scale,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: palette.ink,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 14.5 * scale,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: palette.muted,
      ),
      bodySmall: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 12.5 * scale,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: palette.muted,
      ),
      labelLarge: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 12 * scale,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5 * scale,
        color: palette.muted,
      ),
      labelMedium: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 11 * scale,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1 * scale,
        color: palette.muted,
      ),
    );

    final scheme = ColorScheme(
      brightness: brightness,
      primary: palette.forest,
      onPrimary: palette.onForest,
      primaryContainer: palette.lime,
      onPrimaryContainer: palette.forestDeep,
      secondary: palette.lime,
      onSecondary: palette.forestDeep,
      secondaryContainer: palette.wash,
      onSecondaryContainer: palette.ink,
      tertiary: palette.clay,
      onTertiary: palette.surface,
      error: palette.clay,
      onError: palette.surface,
      surface: palette.surface,
      onSurface: palette.ink,
      surfaceContainerHighest: palette.wash,
      surfaceContainerHigh: palette.wash,
      surfaceContainer: palette.surface,
      outline: palette.line,
      outlineVariant: palette.line,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: palette.ink,
      onInverseSurface: palette.surface,
      inversePrimary: palette.lime,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.canvas,
      canvasColor: palette.canvas,
      fontFamily: 'PlusJakartaSans',
      textTheme: textTheme,
      extensions: [palette],
      splashFactory: InkRipple.splashFactory,
      highlightColor: Colors.transparent,
      dividerColor: palette.line,
      iconTheme: IconThemeData(color: palette.ink, size: 20 * scale),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: palette.ink,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: palette.forest,
        selectionColor: palette.lime.withValues(alpha: 0.7),
        selectionHandleColor: palette.forest,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.raised,
        hintStyle: textTheme.bodyMedium,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16 * scale,
          vertical: 16 * scale,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.forest, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.clay),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.clay, width: 1.6),
        ),
        errorStyle: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 12 * scale,
          height: 1.4,
          color: palette.clay,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: palette.forestDeep,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 12 * scale,
          color: TunasPalette.light.onForest,
        ),
      ),
    );
  }
}
