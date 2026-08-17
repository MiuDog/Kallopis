import 'package:flutter/material.dart';

import '../foundation/pln_metrics.dart';
import '../interaction/pln_pressable.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

enum PlnButtonTone { primary, secondary, ghost, danger }

class PlnButton extends StatefulWidget {
  const PlnButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.tone = PlnButtonTone.secondary,
    this.leading,
    this.trailing,
    this.compact = false,
    this.onLongPress,
  });

  final String label;
  final VoidCallback? onPressed;
  final PlnButtonTone tone;
  final Widget? leading;
  final Widget? trailing;
  final bool compact;
  final VoidCallback? onLongPress;

  @override
  State<PlnButton> createState() => _PlnButtonState();
}

class _PlnButtonState extends State<PlnButton> {
  bool _hovered = false;
  bool _focused = false;

  void _setHovered(bool value) => setState(() => _hovered = value);

  void _setFocused(bool value) => setState(() => _focused = value);

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final disabled = widget.onPressed == null;
    final active = (_hovered || _focused) && !disabled;
    final background = disabled
        ? tokens.surfaceInset
        : switch (widget.tone) {
            PlnButtonTone.primary =>
              active
                  ? Color.lerp(tokens.interaction, tokens.text, 0.12)!
                  : tokens.interaction,
            PlnButtonTone.secondary =>
              active ? tokens.hoverSurface : tokens.component,
            PlnButtonTone.ghost =>
              active ? tokens.hoverSurface : const Color(0x00000000),
            PlnButtonTone.danger => tokens.danger.withValues(
              alpha: active ? 0.24 : 0.16,
            ),
          };
    final foreground = disabled
        ? tokens.textFaint
        : switch (widget.tone) {
            PlnButtonTone.primary => PlnThemeContrast.foregroundFor(background),
            PlnButtonTone.danger => tokens.danger,
            PlnButtonTone.secondary || PlnButtonTone.ghost => tokens.text,
          };
    final content = Container(
      height: widget.compact ? PlnSize.controlSmall : PlnSize.control,
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? PlnSpace.sm : PlnSpace.md,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(PlnRadius.control),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.leading != null) ...[
            widget.leading!,
            const SizedBox(width: PlnSpace.sm),
          ],
          Flexible(
            child: PlnText(
              widget.label,
              role: PlnTextRole.body,
              color: foreground,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.trailing != null) ...[
            const SizedBox(width: PlnSpace.sm),
            widget.trailing!,
          ],
        ],
      ),
    );

    return Material(
      color: const Color(0x00000000),
      child: PlnPressable(
        onPressed: widget.onPressed,
        onLongPress: widget.onLongPress,
        longPressProgressColor: tokens.interactionSoft.withValues(alpha: 0.55),
        onHover: _setHovered,
        onFocusChange: _setFocused,
        borderRadius: BorderRadius.circular(PlnRadius.control),
        child: content,
      ),
    );
  }
}
