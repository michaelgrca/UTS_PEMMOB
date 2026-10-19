import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';

/// Animated score dial used on the result screen.
class ScoreDial extends StatelessWidget {
  const ScoreDial({super.key, required this.correct, required this.total});

  final int correct;
  final int total;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scale = context.typeScale;
    final diameter = 190 * scale;
    final score = total == 0 ? 0.0 : correct / total;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: score),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return SizedBox.square(
          dimension: diameter,
          child: CustomPaint(
            painter: _DialPainter(
              progress: value,
              track: palette.line,
              arc: palette.forest,
              accent: palette.lime,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${(value * total).round()}',
                          style: TextStyle(
                            fontFamily: 'Fraunces',
                            fontSize: 58 * scale,
                            height: 1,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -2,
                            color: palette.ink,
                          ),
                        ),
                        TextSpan(
                          text: '/$total',
                          style: TextStyle(
                            fontFamily: 'Fraunces',
                            fontSize: 24 * scale,
                            fontWeight: FontWeight.w400,
                            color: palette.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4 * scale),
                  Text(
                    'jawaban benar',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DialPainter extends CustomPainter {
  const _DialPainter({
    required this.progress,
    required this.track,
    required this.arc,
    required this.accent,
  });

  final double progress;
  final Color track;
  final Color arc;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final stroke = size.shortestSide * 0.052;
    final rect = Rect.fromCircle(center: center, radius: radius - stroke);

    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawCircle(center, radius - stroke, trackPaint);

    final arcPaint = Paint()
      ..color = arc
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final sweep = -math.pi / 2 + (math.pi * 2 * progress);
    if (progress > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        math.pi * 2 * progress,
        false,
        arcPaint,
      );
    }

    final dotPaint = Paint()..color = accent;
    final dotRadius = stroke * 0.72;
    if (progress > 0) {
      canvas.drawCircle(
        Offset(
          center.dx + math.cos(sweep) * (radius - stroke),
          center.dy + math.sin(sweep) * (radius - stroke),
        ),
        dotRadius,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_DialPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.track != track ||
      oldDelegate.arc != arc ||
      oldDelegate.accent != accent;
}
