import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';

/// The sprout mark and wordmark. The sprout is painted rather than imported so
/// it stays crisp at any size.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scale = context.typeScale;
    final markSize = (compact ? 32.0 : 38.0) * scale;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: markSize,
          height: markSize,
          decoration: BoxDecoration(
            color: palette.lime,
            borderRadius: BorderRadius.circular(markSize * 0.3),
          ),
          child: Padding(
            padding: EdgeInsets.all(markSize * 0.2),
            child: CustomPaint(
              painter: _SproutPainter(color: palette.forestDeep),
            ),
          ),
        ),
        SizedBox(width: 10 * scale),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Fraunces',
              fontSize: (compact ? 21 : 24) * scale,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.6,
              color: palette.ink,
            ),
            children: [
              const TextSpan(text: 'tunas'),
              TextSpan(
                text: '.',
                style: TextStyle(color: palette.clay),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SproutPainter extends CustomPainter {
  const _SproutPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stem = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.075
      ..strokeCap = StrokeCap.round;

    final stemPath = Path()
      ..moveTo(w * 0.5, h * 0.9)
      ..cubicTo(w * 0.48, h * 0.68, w * 0.52, h * 0.5, w * 0.5, h * 0.24);
    canvas.drawPath(stemPath, stem);

    final leaf = Paint()..color = color;

    final left = Path()
      ..moveTo(w * 0.5, h * 0.56)
      ..cubicTo(w * 0.28, h * 0.57, w * 0.12, h * 0.42, w * 0.14, h * 0.2)
      ..cubicTo(w * 0.37, h * 0.22, w * 0.51, h * 0.36, w * 0.5, h * 0.56)
      ..close();
    canvas.drawPath(left, leaf);

    final right = Path()
      ..moveTo(w * 0.5, h * 0.46)
      ..cubicTo(w * 0.68, h * 0.46, w * 0.84, h * 0.32, w * 0.83, h * 0.13)
      ..cubicTo(w * 0.62, h * 0.15, w * 0.49, h * 0.28, w * 0.5, h * 0.46)
      ..close();
    canvas.drawPath(right, leaf);
  }

  @override
  bool shouldRepaint(_SproutPainter oldDelegate) => oldDelegate.color != color;
}
