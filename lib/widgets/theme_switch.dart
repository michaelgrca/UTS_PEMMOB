import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';
import '../state/theme_controller.dart';

import 'package:provider/provider.dart';

/// Circular light/dark toggle with a small sliding knob. Reused in every top
/// bar so the preference is always one tap away.
class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final controller = context.watch<ThemeController>();
    final isDark = controller.isDark(context);
    final scale = context.typeScale;

    return Tooltip(
      message: isDark ? 'Mode terang' : 'Mode gelap',
      excludeFromSemantics: true,
      child: Semantics(
        button: true,
        label: isDark ? 'Aktifkan mode terang' : 'Aktifkan mode gelap',
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => controller.toggle(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: 66 * scale,
              height: 34 * scale,
              padding: EdgeInsets.all(3 * scale),
              decoration: BoxDecoration(
                color: palette.wash,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: palette.line),
              ),
              child: Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    alignment: isDark
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 26 * scale,
                      height: 26 * scale,
                      decoration: BoxDecoration(
                        color: isDark ? palette.lime : palette.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 160),
                        child: Icon(
                          isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          key: ValueKey(isDark),
                          size: 14 * scale,
                          color: isDark ? palette.forestDeep : palette.forest,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
