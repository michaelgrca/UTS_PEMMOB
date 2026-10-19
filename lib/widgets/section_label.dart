import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';

/// Small uppercase kicker with a rule, used to introduce sections.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final ink = color ?? palette.forest;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 18 * context.typeScale, height: 1.5, color: ink),
        SizedBox(width: 8 * context.typeScale),
        Flexible(
          child: Text(
            text.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ink),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
