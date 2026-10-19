import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';

/// Page background: warm paper, a faint topographic texture and one soft
/// radial glow. Reused by every screen so the app feels like one place.
class TunasBackdrop extends StatelessWidget {
  const TunasBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final width = context.viewport.width;
    final textureSize = (width * 0.92).clamp(420.0, 900.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: palette.canvas),
        Positioned(
          top: -textureSize * 0.22,
          right: -textureSize * 0.26,
          width: textureSize,
          height: textureSize,
          child: IgnorePointer(
            child: Image.asset(
              'assets/images/contour.png',
              fit: BoxFit.cover,
              color: palette.texture.withValues(alpha: 0.06),
              colorBlendMode: BlendMode.srcIn,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
        Positioned(
          left: -width * 0.28,
          bottom: -width * 0.34,
          width: width * 0.8,
          height: width * 0.8,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    palette.lime.withValues(alpha: 0.34),
                    palette.lime.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
