import 'package:flutter/material.dart';

import 'klp_control_size.dart';
import '../interaction/klp_pressable.dart';
import '../surface/klp_dashed_border.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

enum KlpButtonTone { primary, secondary, ghost, dashed, danger }

/// 主要動作按鈕。`tone` 決定語意強度（primary／secondary／ghost／dashed／danger），
/// `size` 支援五段標準尺寸階級（xs: 30px, sm: 36px, md: 40px, lg: 48px, xl: 56px），
/// 預設使用 sm，`compact` 使用 xs；`selected` 是由呼叫端持有的持續選取狀態。
/// 圓角、內距、高度、狀態 wash 與邊框皆取自 theme。
class KlpButton extends StatefulWidget {
  const KlpButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.tone = KlpButtonTone.primary,
    this.size,
    this.leading,
    this.trailing,
    this.compact = false,
		this.selected = false,
    this.onLongPress,
  });

  final String label;
  final VoidCallback? onPressed;
  final KlpButtonTone tone;
  final KlpControlSize? size;
  final Widget? leading;
  final Widget? trailing;
  final bool compact;
	final bool selected;
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
    final klp = context.klp;
    final disabled = widget.onPressed == null;
    final active = (_hovered || _focused) && !disabled;
    final radius = klp.buttonRadius;
    final background = disabled
        ? tokens.surfaceInset
        : switch (widget.tone) {
			KlpButtonTone.primary => tokens.interactionSoft,
            KlpButtonTone.secondary => tokens.component,
            KlpButtonTone.ghost => tokens.clear,
            KlpButtonTone.dashed => tokens.clear,
            KlpButtonTone.danger => tokens.danger.withValues(
              alpha: klp.surface.statusFillOpacity,
            ),
          };
		Color? stateWash;
		if (widget.selected && !disabled) {
			stateWash = tokens.interaction.withValues(alpha: klp.surface.focusWashOpacity);
		} else if (active) {
			stateWash = klp.selectionWash;
		}
		final effectiveBackground = stateWash == null ? background : Color.alphaBlend(stateWash, background);
    final foreground = disabled
        ? tokens.textFaint
        : switch (widget.tone) {
			KlpButtonTone.primary => tokens.interaction,
            KlpButtonTone.danger => tokens.danger,
            KlpButtonTone.secondary ||
            KlpButtonTone.ghost ||
            KlpButtonTone.dashed => tokens.text,
          };
		final resolvedSize = widget.size ?? (widget.compact ? KlpControlSize.xs : KlpControlSize.sm);
    final (height, insets, textRole) = switch (resolvedSize) {
      KlpControlSize.xs => (
        klp.space.controlHeightXSmall,
        EdgeInsets.symmetric(horizontal: klp.space.compact),
        KlpTextRole.caption,
      ),
      KlpControlSize.sm => (
        klp.space.controlHeightSmall,
        EdgeInsets.symmetric(horizontal: klp.space.controlPaddingXSmall),
		KlpTextRole.caption,
      ),
      KlpControlSize.md => (
        klp.buttonHeight,
        EdgeInsets.symmetric(horizontal: klp.buttonInsets.left),
        KlpTextRole.body,
      ),
      KlpControlSize.lg => (
        klp.space.controlHeightLarge,
        EdgeInsets.symmetric(horizontal: klp.space.controlPaddingXLarge),
        KlpTextRole.lead,
      ),
      KlpControlSize.xl => (
        klp.space.controlHeightXLarge,
        EdgeInsets.symmetric(horizontal: klp.space.controlPaddingXXLarge),
        KlpTextRole.lead,
      ),
    };

    Widget content = Container(
      height: height,
      padding: insets,
      decoration: BoxDecoration(
        color: effectiveBackground,
        borderRadius: BorderRadius.circular(radius),
        border: klp.buttonBorderWidth == klp.shape.none
            ? null
            : Border.all(color: tokens.border, width: klp.buttonBorderWidth),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: foreground),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.leading != null) ...[
              widget.leading!,
              SizedBox(width: klp.space.compact),
            ],
            Flexible(
              child: KlpText(
                widget.label,
                role: textRole,
                color: foreground,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.trailing != null) ...[
              SizedBox(width: klp.space.compact),
              widget.trailing!,
            ],
          ],
        ),
      ),
    );

    if (widget.tone == KlpButtonTone.dashed) {
      content = KlpDashedBorder(radius: radius, child: content);
    }

		final pressable = Material(
      color: tokens.clear,
      child: KlpPressable(
        onPressed: widget.onPressed,
        onLongPress: widget.onLongPress,
        longPressProgressColor: tokens.interactionSoft.withValues(
          alpha: klp.surface.pressProgressOpacity,
        ),
        onHover: _setHovered,
        onFocusChange: _setFocused,
        hoverHighlight: false,
        borderRadius: BorderRadius.circular(radius),
        child: content,
      ),
    );
		return Semantics(selected: widget.selected, child: pressable);
  }
}
