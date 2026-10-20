import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';
import 'brand_mark.dart';
import 'theme_switch.dart';

/// Shared header used on every screen: optional leading control, the wordmark
/// and a theme switch.
class TunasTopBar extends StatelessWidget {
  const TunasTopBar({
    super.key,
    this.leading,
    this.brand = true,
    this.compactBrand = false,
    this.actions = const [],
  });

  final Widget? leading;
  final bool brand;
  final bool compactBrand;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final scale = context.typeScale;
    return Row(
      children: [
        if (leading != null) ...[leading!, SizedBox(width: 12 * scale)],
        if (brand) BrandMark(compact: compactBrand),
        const Spacer(),
        for (var i = 0; i < actions.length; i++) ...[
          actions[i],
          if (i < actions.length - 1) SizedBox(width: 8 * scale),
        ],
        if (actions.isNotEmpty) SizedBox(width: 10 * scale),
        const ThemeSwitch(),
      ],
    );
  }
}

/// Round, hairline-bordered icon button used for back/close actions.
class TunasIconButton extends StatelessWidget {
  const TunasIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scale = context.typeScale;
    final button = AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: onPressed == null ? 0.4 : 1,
      child: Semantics(
        button: true,
        enabled: onPressed != null,
        label: tooltip,
        child: Material(
          color: filled ? palette.wash : palette.surface,
          shape: CircleBorder(side: BorderSide(color: palette.line)),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox.square(
              dimension: 42 * scale,
              child: Icon(icon, size: 19 * scale, color: palette.ink),
            ),
          ),
        ),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(
      message: tooltip!,
      excludeFromSemantics: true,
      child: button,
    );
  }
}
