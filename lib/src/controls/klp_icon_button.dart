import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../overlay/klp_tooltip.dart';
import '../theme/klp_theme.dart';

/// 只有圖示的按鈕。`label` 為必填且用於無障礙標註——圖示本身沒有可讀文字，
/// 沒有 label 的圖示按鈕對螢幕閱讀器等於不存在。
class KlpIconButton extends StatefulWidget {
  const KlpIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.quarterTurns = 0,
  });

  final String icon;
  final String label;
  final VoidCallback? onPressed;
  final bool selected;
  final int quarterTurns;

  @override
  State<KlpIconButton> createState() => _KlpIconButtonState();
}

class _KlpIconButtonState extends State<KlpIconButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;
    final active = (_hovered || _focused) && widget.onPressed != null;
    final background = widget.selected
        ? tokens.selectionBackground
        : active
        ? Color.alphaBlend(klp.selectionWash, tokens.component)
        : tokens.component;
    final button = Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(klp.shape.control),
      ),
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        borderRadius: BorderRadius.circular(klp.shape.control),
        child: SizedBox.square(
          dimension: klp.space.iconButton,
          child: Center(
            child: RotatedBox(
              quarterTurns: widget.quarterTurns,
              child: KlpIcon(
                widget.icon,
                color: widget.onPressed == null
                    ? tokens.textFaint
                    : tokens.text,
              ),
            ),
          ),
        ),
      ),
    );

    return KlpTooltip(
      message: widget.label,
      child: Semantics(
        button: true,
        selected: widget.selected,
        label: widget.label,
        child: button,
      ),
    );
  }
}
