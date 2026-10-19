import 'package:flutter/widgets.dart';

/// Layout breakpoints and a single source of truth for spacing and type
/// scaling. Every screen derives its paddings and font sizes from here so the
/// UI grows with the device instead of relying on fixed pixel values.
enum WindowSize { compact, medium, expanded }

extension ResponsiveContext on BuildContext {
  Size get viewport => MediaQuery.sizeOf(this);

  WindowSize get windowSize {
    final width = viewport.width;
    if (width < 640) return WindowSize.compact;
    if (width < 1024) return WindowSize.medium;
    return WindowSize.expanded;
  }

  bool get isCompact => windowSize == WindowSize.compact;
  bool get isExpanded => windowSize == WindowSize.expanded;

  /// Horizontal page margin: tight on phones, generous on desktop.
  double get gutter => switch (windowSize) {
    WindowSize.compact => 20,
    WindowSize.medium => 40,
    WindowSize.expanded => 56,
  };

  /// Width of the main reading column.
  double get contentWidth => switch (windowSize) {
    WindowSize.compact => double.infinity,
    WindowSize.medium => 720,
    WindowSize.expanded => 1120,
  };

  /// Type is tied to the shortest side of the window, capped so tablet and
  /// desktop layouts stay composed rather than turning into billboards.
  double get typeScale => (viewport.shortestSide / 400).clamp(0.92, 1.16);

  double sp(double size) => size * typeScale;

  EdgeInsets get pagePadding =>
      EdgeInsets.symmetric(horizontal: gutter, vertical: sp(20));
}
