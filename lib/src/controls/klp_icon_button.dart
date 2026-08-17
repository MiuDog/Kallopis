import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_metrics.dart';
import '../overlay/klp_tooltip.dart';
import '../theme/klp_theme.dart';

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
    final active = (_hovered || _focused) && widget.onPressed != null;
    final button = Material(
      color: widget.selected
          ? tokens.selectionBackground
          : active
          ? tokens.hoverSurface
          : tokens.component,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KlpRadius.control),
      ),
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        borderRadius: BorderRadius.circular(KlpRadius.control),
        child: SizedBox.square(
          dimension: KlpSize.iconButton,
          child: Center(
            child: RotatedBox(
              quarterTurns: widget.quarterTurns,
              child: KlpIcon(
                widget.icon,
                color: widget.onPressed == null
                    ? tokens.textFaint
                    : widget.selected
                    ? tokens.selectionForeground
                    : active
                    ? tokens.interaction
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
