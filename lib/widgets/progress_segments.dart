import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';

/// Thin segmented progress rail. Answered questions are solid, the current one
/// is highlighted, upcoming ones stay quiet.
class ProgressSegments extends StatelessWidget {
  const ProgressSegments({
    super.key,
    required this.total,
    required this.currentIndex,
    required this.answered,
    required this.isAnswered,
  });

  final int total;
  final int currentIndex;
  final int answered;
  final bool Function(int index) isAnswered;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scale = context.typeScale;

    return Semantics(
      label: '$answered dari $total pertanyaan terjawab',
      child: Row(
        children: [
          for (var i = 0; i < total; i++) ...[
            if (i > 0) SizedBox(width: 5 * scale),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOut,
                height: 5 * scale,
                decoration: BoxDecoration(
                  color: i == currentIndex
                      ? palette.forest
                      : isAnswered(i)
                      ? palette.forest.withValues(alpha: 0.55)
                      : palette.line,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
