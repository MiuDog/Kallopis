import 'package:flutter/material.dart';

import 'klp_control_size.dart';
import '../interaction/klp_pressable.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

enum KlpButtonTone { primary, secondary, ghost, danger }

/// 主要動作按鈕。`tone` 決定語意強度（primary／secondary／ghost／danger），
/// `size` 支援四段標準尺寸階級（sm: 32px, md: 40px, lg: 48px, xl: 56px），
/// 圓角、內距、高度與邊框皆取自 theme。
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
    this.onLongPress,
  });

  final String label;
  final VoidCallback? onPressed;
  final KlpButtonTone tone;
  final KlpControlSize? size;
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
    final klp = context.klp;
    final disabled = widget.onPressed == null;
    final active = (_hovered || _focused) && !disabled;
    final radius = klp.buttonRadius;
    final background = disabled
        ? tokens.surfaceInset
        : switch (widget.tone) {
            KlpButtonTone.primary => tokens.interaction,
            KlpButtonTone.secondary => tokens.component,
            KlpButtonTone.ghost => tokens.clear,
            KlpButtonTone.danger => tokens.danger.withValues(
              alpha: klp.surface.statusFillOpacity,
            ),
          };
    final effectiveBackground = active
        ? Color.alphaBlend(klp.selectionWash, background)
        : background;
    final foreground = disabled
        ? tokens.textFaint
        : switch (widget.tone) {
            KlpButtonTone.primary => KlpThemeContrast.foregroundFor(background),
            KlpButtonTone.danger => tokens.danger,
            KlpButtonTone.secondary || KlpButtonTone.ghost => tokens.text,
          };
    final resolvedSize =
        widget.size ?? (widget.compact ? KlpControlSize.sm : KlpControlSize.md);
    final (height, insets, textRole) = switch (resolvedSize) {
      KlpControlSize.sm => (
        klp.space.controlHeightSmall,
        EdgeInsets.symmetric(horizontal: klp.space.controlPaddingXSmall),
        KlpTextRole.sub,
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
    );

    return Material(
      color: tokens.clear,
      child: KlpPressable(
        onPressed: widget.onPressed,
        onLongPress: widget.onLongPress,
        longPressProgressColor: tokens.interactionSoft.withValues(
          alpha: klp.surface.pressProgressOpacity,
        ),
        onHover: _setHovered,
        onFocusChange: _setFocused,
        showHoverBorder: false,
        borderRadius: BorderRadius.circular(radius),
        child: content,
      ),
    );
  }
}
