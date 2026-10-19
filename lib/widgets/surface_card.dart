import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';

/// A soft panel used for the start card, quiz body and result summary.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.radius = 26,
    this.border = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double radius;
  final bool border;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scale = context.typeScale;
    return Container(
      padding: padding ?? EdgeInsets.all(22 * scale),
      decoration: BoxDecoration(
        color: color ?? palette.surface,
        borderRadius: BorderRadius.circular(radius * scale),
        border: border ? Border.all(color: palette.line) : null,
        boxShadow: [
          BoxShadow(
            color: palette.forestDeep.withValues(alpha: 0.05),
            blurRadius: 30 * scale,
            offset: Offset(0, 14 * scale),
          ),
        ],
      ),
      child: child,
    );
  }
}
