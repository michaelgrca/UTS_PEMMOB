import 'package:flutter/material.dart';

/// Colour tokens for the two Tunas themes. Kept as a [ThemeExtension] so the
/// palette can animate together with the rest of the theme when the user
/// flips between light and dark mode.
@immutable
class TunasPalette extends ThemeExtension<TunasPalette> {
  const TunasPalette({
    required this.canvas,
    required this.surface,
    required this.raised,
    required this.wash,
    required this.ink,
    required this.muted,
    required this.line,
    required this.forest,
    required this.forestDeep,
    required this.lime,
    required this.clay,
    required this.onForest,
    required this.texture,
  });

  final Color canvas;
  final Color surface;
  final Color raised;
  final Color wash;
  final Color ink;
  final Color muted;
  final Color line;
  final Color forest;
  final Color forestDeep;
  final Color lime;
  final Color clay;
  final Color onForest;
  final Color texture;

  static const TunasPalette light = TunasPalette(
    canvas: Color(0xFFF4F0E5),
    surface: Color(0xFFFBF8F0),
    raised: Color(0xFFFFFFFF),
    wash: Color(0xFFECEDDF),
    ink: Color(0xFF15251C),
    muted: Color(0xFF5C6D61),
    line: Color(0xFFDDD8C7),
    forest: Color(0xFF16543B),
    forestDeep: Color(0xFF0B3626),
    lime: Color(0xFFDCE9B6),
    clay: Color(0xFFB25F3B),
    onForest: Color(0xFFF8F5EA),
    texture: Color(0xFF16543B),
  );

  static const TunasPalette dark = TunasPalette(
    canvas: Color(0xFF0D1612),
    surface: Color(0xFF14211B),
    raised: Color(0xFF192820),
    wash: Color(0xFF203128),
    ink: Color(0xFFEDF3E7),
    muted: Color(0xFF9EB1A4),
    line: Color(0xFF2C3D33),
    forest: Color(0xFFA9D5B6),
    forestDeep: Color(0xFF0A2A1D),
    lime: Color(0xFFD2E4A4),
    clay: Color(0xFFE39970),
    onForest: Color(0xFF0B2117),
    texture: Color(0xFFA9D5B6),
  );

  @override
  TunasPalette copyWith({
    Color? canvas,
    Color? surface,
    Color? raised,
    Color? wash,
    Color? ink,
    Color? muted,
    Color? line,
    Color? forest,
    Color? forestDeep,
    Color? lime,
    Color? clay,
    Color? onForest,
    Color? texture,
  }) {
    return TunasPalette(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      raised: raised ?? this.raised,
      wash: wash ?? this.wash,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      line: line ?? this.line,
      forest: forest ?? this.forest,
      forestDeep: forestDeep ?? this.forestDeep,
      lime: lime ?? this.lime,
      clay: clay ?? this.clay,
      onForest: onForest ?? this.onForest,
      texture: texture ?? this.texture,
    );
  }

  @override
  TunasPalette lerp(ThemeExtension<TunasPalette>? other, double t) {
    if (other is! TunasPalette) return this;
    return TunasPalette(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      raised: Color.lerp(raised, other.raised, t)!,
      wash: Color.lerp(wash, other.wash, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      line: Color.lerp(line, other.line, t)!,
      forest: Color.lerp(forest, other.forest, t)!,
      forestDeep: Color.lerp(forestDeep, other.forestDeep, t)!,
      lime: Color.lerp(lime, other.lime, t)!,
      clay: Color.lerp(clay, other.clay, t)!,
      onForest: Color.lerp(onForest, other.onForest, t)!,
      texture: Color.lerp(texture, other.texture, t)!,
    );
  }
}

extension TunasPaletteContext on BuildContext {
  TunasPalette get palette =>
      Theme.of(this).extension<TunasPalette>() ?? TunasPalette.light;
}
