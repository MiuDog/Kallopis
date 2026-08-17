import 'package:flutter/material.dart';

import '../foundation/pln_icon.dart';
import '../foundation/pln_metrics.dart';
import '../overlay/pln_tooltip.dart';
import '../theme/pln_theme.dart';

class PlnIconButton extends StatefulWidget {
  const PlnIconButton({
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
  State<PlnIconButton> createState() => _PlnIconButtonState();
}

class _PlnIconButtonState extends State<PlnIconButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final active = (_hovered || _focused) && widget.onPressed != null;
    final button = Material(
      color: widget.selected
          ? tokens.selectionBackground
          : active
          ? tokens.hoverSurface
          : tokens.component,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PlnRadius.control),
      ),
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        borderRadius: BorderRadius.circular(PlnRadius.control),
        child: SizedBox.square(
          dimension: PlnSize.iconButton,
          child: Center(
            child: RotatedBox(
              quarterTurns: widget.quarterTurns,
              child: PlnIcon(
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

    return PlnTooltip(
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
