import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';
import '../models/quiz_category.dart';

/// Selectable topic row used on the home screen.
class CategoryOption extends StatelessWidget {
  const CategoryOption({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final QuizCategory category;
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
      label: '${category.name}. ${category.tagline}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14 * scale),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal: 12 * scale,
              vertical: 11 * scale,
            ),
            decoration: BoxDecoration(
              color: selected ? palette.wash : Colors.transparent,
              borderRadius: BorderRadius.circular(14 * scale),
              border: Border.all(
                color: selected ? palette.forest : palette.line,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38 * scale,
                  height: 38 * scale,
                  decoration: BoxDecoration(
                    color: selected ? palette.forest : palette.surface,
                    borderRadius: BorderRadius.circular(10 * scale),
                    border: Border.all(
                      color: selected ? palette.forest : palette.line,
                    ),
                  ),
                  child: Icon(
                    category.icon,
                    size: 19 * scale,
                    color: selected ? palette.lime : palette.muted,
                  ),
                ),
                SizedBox(width: 12 * scale),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: textTheme.titleSmall?.copyWith(
                          color: palette.ink,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2 * scale),
                      Text(
                        category.tagline,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 11.5 * scale,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8 * scale),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 18 * scale,
                  height: 18 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? palette.forest : Colors.transparent,
                    border: Border.all(
                      color: selected ? palette.forest : palette.line,
                      width: 1.4,
                    ),
                  ),
                  child: selected
                      ? Icon(
                          Icons.check_rounded,
                          size: 12 * scale,
                          color: palette.lime,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
