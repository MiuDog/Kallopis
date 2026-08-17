import 'package:flutter/material.dart';

import '../foundation/pln_icon.dart';
import '../foundation/pln_icons.dart';
import '../foundation/pln_metrics.dart';
import '../overlay/pln_tooltip.dart';
import '../theme/pln_theme.dart';

class PlnWindowControls extends StatelessWidget {
  const PlnWindowControls({
    super.key,
    required this.onMinimize,
    required this.onToggleMaximize,
    required this.onClose,
    this.isMaximized = false,
    this.minimizeKey,
    this.maximizeKey,
    this.closeKey,
  });

  final VoidCallback? onMinimize;
  final VoidCallback? onToggleMaximize;
  final VoidCallback? onClose;
  final bool isMaximized;
  final Key? minimizeKey;
  final Key? maximizeKey;
  final Key? closeKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WindowControlButton(
          key: minimizeKey,
          icon: PlnIcons.minus,
          label: 'Minimize window',
          onPressed: onMinimize,
        ),
        _WindowControlButton(
          key: maximizeKey,
          icon: PlnIcons.maximize,
          label: isMaximized ? 'Restore window' : 'Maximize window',
          onPressed: onToggleMaximize,
        ),
        _WindowControlButton(
          key: closeKey,
          icon: PlnIcons.x,
          label: 'Close window',
          onPressed: onClose,
          destructive: true,
        ),
      ],
    );
  }
}

class _WindowControlButton extends StatefulWidget {
  const _WindowControlButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.destructive = false,
  });

  final String icon;
  final String label;
  final VoidCallback? onPressed;
  final bool destructive;

  @override
  State<_WindowControlButton> createState() => _WindowControlButtonState();
}

class _WindowControlButtonState extends State<_WindowControlButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final enabled = widget.onPressed != null;
    final active = enabled && (_hovered || _focused);
    final color = !enabled
        ? tokens.textFaint
        : active && widget.destructive
        ? tokens.danger
        : active
        ? tokens.interaction
        : tokens.textMuted;

    return PlnTooltip(
      message: widget.label,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: widget.label,
        child: Material(
          color: active
              ? widget.destructive
                    ? tokens.danger.withValues(alpha: 0.16)
                    : tokens.hoverSurface
              : const Color(0x00000000),
          borderRadius: BorderRadius.circular(PlnRadius.control),
          child: InkWell(
            onTap: widget.onPressed,
            onHover: (value) => setState(() => _hovered = value),
            onFocusChange: (value) => setState(() => _focused = value),
            borderRadius: BorderRadius.circular(PlnRadius.control),
            child: SizedBox.square(
              dimension: PlnSize.controlSmall,
              child: Center(
                child: PlnIcon(
                  widget.icon,
                  size: PlnSize.iconSmall,
                  color: color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
