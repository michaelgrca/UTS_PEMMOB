import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';
import '../models/question.dart';

/// One answer row with an A–D key, label and selected state.
class QuizOptionTile extends StatelessWidget {
  const QuizOptionTile({
    super.key,
    required this.index,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final int index;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scale = context.typeScale;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      selected: selected,
      label: 'Pilihan ${Question.optionKeys[index]}. $text',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16 * scale),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 170),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal: 14 * scale,
              vertical: 13 * scale,
            ),
            decoration: BoxDecoration(
              color: selected ? palette.forest : palette.surface,
              borderRadius: BorderRadius.circular(16 * scale),
              border: Border.all(
                color: selected ? palette.forest : palette.line,
                width: selected ? 1.5 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: palette.forestDeep.withValues(alpha: 0.14),
                        blurRadius: 18 * scale,
                        offset: Offset(0, 8 * scale),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 170),
                  width: 34 * scale,
                  height: 34 * scale,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? palette.lime : palette.wash,
                    borderRadius: BorderRadius.circular(9 * scale),
                  ),
                  child: Text(
                    Question.optionKeys[index],
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.w700,
                      color: selected ? palette.forestDeep : palette.muted,
                    ),
                  ),
                ),
                SizedBox(width: 13 * scale),
                Expanded(
                  child: Text(
                    text,
                    style: textTheme.bodyLarge?.copyWith(
                      color: selected ? palette.onForest : palette.ink,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (selected) ...[
                  SizedBox(width: 10 * scale),
                  Container(
                    width: 22 * scale,
                    height: 22 * scale,
                    decoration: BoxDecoration(
                      color: palette.lime,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 14 * scale,
                      color: palette.forestDeep,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
