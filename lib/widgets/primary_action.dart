import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';

/// The one call-to-action style used across the app: a deep green pill with a
/// trailing lime arrow. [expand] controls whether it fills its parent.
class PrimaryAction extends StatelessWidget {
  const PrimaryAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward_rounded,
    this.expand = true,
    this.tone = ActionTone.forest,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final ActionTone tone;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scale = context.typeScale;
    final enabled = onPressed != null;
    final background = switch (tone) {
      ActionTone.forest => palette.forest,
      ActionTone.lime => palette.lime,
    };
    final foreground = switch (tone) {
      ActionTone.forest => palette.onForest,
      ActionTone.lime => palette.forestDeep,
    };

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 15 * scale,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
              color: foreground,
            ),
          ),
        ),
        if (icon != null) ...[
          SizedBox(width: 12 * scale),
          Container(
            width: 26 * scale,
            height: 26 * scale,
            decoration: BoxDecoration(
              color: tone == ActionTone.forest
                  ? palette.lime
                  : palette.forestDeep,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 15 * scale,
              color: tone == ActionTone.forest
                  ? palette.forestDeep
                  : palette.lime,
            ),
          ),
        ],
      ],
    );

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: AnimatedOpacity(
        opacity: enabled ? 1 : 0.5,
        duration: const Duration(milliseconds: 160),
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(15 * scale),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(15 * scale),
            child: Container(
              height: 54 * scale,
              width: expand ? double.infinity : null,
              padding: EdgeInsets.symmetric(horizontal: 20 * scale),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15 * scale),
                border: Border.all(
                  color: tone == ActionTone.forest
                      ? Colors.transparent
                      : palette.forest.withValues(alpha: 0.15),
                ),
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

enum ActionTone { forest, lime }
