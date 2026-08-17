import 'package:flutter/material.dart';

import '../foundation/klp_metrics.dart';
import '../interaction/klp_pressable.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

enum KlpButtonTone { primary, secondary, ghost, danger }

class KlpButton extends StatefulWidget {
  const KlpButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.tone = KlpButtonTone.secondary,
    this.leading,
    this.trailing,
    this.compact = false,
    this.onLongPress,
  });

  final String label;
  final VoidCallback? onPressed;
  final KlpButtonTone tone;
  final Widget? leading;
  final Widget? trailing;
  final bool compact;
  final VoidCallback? onLongPress;

  @override
  State<KlpButton> createState() => _KlpButtonState();
}

class _KlpButtonState extends State<KlpButton> {
  bool _hovered = false;
  bool _focused = false;

  void _setHovered(bool value) => setState(() => _hovered = value);

  void _setFocused(bool value) => setState(() => _focused = value);

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final disabled = widget.onPressed == null;
    final active = (_hovered || _focused) && !disabled;
    final background = disabled
        ? tokens.surfaceInset
        : switch (widget.tone) {
            KlpButtonTone.primary =>
              active
                  ? Color.lerp(tokens.interaction, tokens.text, 0.12)!
                  : tokens.interaction,
            KlpButtonTone.secondary =>
              active ? tokens.hoverSurface : tokens.component,
            KlpButtonTone.ghost =>
              active ? tokens.hoverSurface : const Color(0x00000000),
            KlpButtonTone.danger => tokens.danger.withValues(
              alpha: active ? 0.24 : 0.16,
            ),
          };
    final foreground = disabled
        ? tokens.textFaint
        : switch (widget.tone) {
            KlpButtonTone.primary => KlpThemeContrast.foregroundFor(background),
            KlpButtonTone.danger => tokens.danger,
            KlpButtonTone.secondary || KlpButtonTone.ghost => tokens.text,
          };
    final content = Container(
      height: widget.compact ? KlpSize.controlSmall : KlpSize.control,
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? KlpSpace.sm : KlpSpace.md,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(KlpRadius.control),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.leading != null) ...[
            widget.leading!,
            const SizedBox(width: KlpSpace.sm),
          ],
          Flexible(
            child: KlpText(
              widget.label,
              role: KlpTextRole.body,
              color: foreground,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.trailing != null) ...[
            const SizedBox(width: KlpSpace.sm),
            widget.trailing!,
          ],
        ],
      ),
    );

    return Material(
      color: const Color(0x00000000),
      child: KlpPressable(
        onPressed: widget.onPressed,
        onLongPress: widget.onLongPress,
        longPressProgressColor: tokens.interactionSoft.withValues(alpha: 0.55),
        onHover: _setHovered,
        onFocusChange: _setFocused,
        borderRadius: BorderRadius.circular(KlpRadius.control),
        child: content,
      ),
    );
  }
}
