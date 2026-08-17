import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../foundation/klp_metrics.dart';
import '../overlay/klp_tooltip.dart';
import '../theme/klp_theme.dart';
import '../foundation/klp_palette.dart';

class KlpWindowControls extends StatelessWidget {
  const KlpWindowControls({
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
          icon: KlpIcons.minus,
          label: 'Minimize window',
          onPressed: onMinimize,
        ),
        _WindowControlButton(
          key: maximizeKey,
          icon: KlpIcons.maximize,
          label: isMaximized ? 'Restore window' : 'Maximize window',
          onPressed: onToggleMaximize,
        ),
        _WindowControlButton(
          key: closeKey,
          icon: KlpIcons.x,
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
    final tokens = context.klpColors;
    final enabled = widget.onPressed != null;
    final active = enabled && (_hovered || _focused);
    final color = !enabled
        ? tokens.textFaint
        : active && widget.destructive
        ? tokens.danger
        : active
        ? tokens.interaction
        : tokens.textMuted;

    return KlpTooltip(
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
              : KlpPalette.transparent,
          borderRadius: BorderRadius.circular(KlpRadius.control),
          child: InkWell(
            onTap: widget.onPressed,
            onHover: (value) => setState(() => _hovered = value),
            onFocusChange: (value) => setState(() => _focused = value),
            borderRadius: BorderRadius.circular(KlpRadius.control),
            child: SizedBox.square(
              dimension: KlpSize.controlSmall,
              child: Center(
                child: KlpIcon(
                  widget.icon,
                  size: KlpSize.iconSmall,
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
