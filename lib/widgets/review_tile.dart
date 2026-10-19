import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';
import '../models/question.dart';

/// One row in the answer review list.
class ReviewTile extends StatelessWidget {
  const ReviewTile({
    super.key,
    required this.number,
    required this.question,
    required this.selectedIndex,
    this.divider = true,
  });

  final int number;
  final Question question;
  final int? selectedIndex;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scale = context.typeScale;
    final textTheme = Theme.of(context).textTheme;
    final correct = selectedIndex == question.answerIndex;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 18 * scale),
      decoration: BoxDecoration(
        border: divider
            ? Border(bottom: BorderSide(color: palette.line))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26 * scale,
            height: 26 * scale,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: correct
                  ? palette.forest
                  : palette.clay.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8 * scale),
            ),
            child: Icon(
              correct ? Icons.check_rounded : Icons.close_rounded,
              size: 15 * scale,
              color: correct ? palette.lime : palette.clay,
            ),
          ),
          SizedBox(width: 12 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      number.toString().padLeft(2, '0'),
                      style: textTheme.labelMedium?.copyWith(
                        color: palette.muted,
                      ),
                    ),
                    SizedBox(width: 10 * scale),
                    Expanded(
                      child: Text(
                        question.prompt,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8 * scale),
                _AnswerLine(
                  label: 'Jawabanmu',
                  value: selectedIndex == null
                      ? 'Belum dijawab'
                      : '${Question.optionKeys[selectedIndex!]}. '
                            '${question.options[selectedIndex!]}',
                  color: correct ? palette.forest : palette.clay,
                ),
                if (!correct) ...[
                  SizedBox(height: 4 * scale),
                  _AnswerLine(
                    label: 'Jawaban benar',
                    value:
                        '${Question.optionKeys[question.answerIndex]}. '
                        '${question.answer}',
                    color: palette.forest,
                  ),
                ],
                SizedBox(height: 8 * scale),
                Text(
                  question.note,
                  style: textTheme.bodySmall?.copyWith(height: 1.55),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerLine extends StatelessWidget {
  const _AnswerLine({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scale = context.typeScale;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: textTheme.bodySmall?.copyWith(
              fontSize: 11.5 * scale,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: value,
            style: textTheme.bodySmall?.copyWith(
              fontSize: 11.5 * scale,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
