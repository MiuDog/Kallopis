import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../l10n/klp_localizations.dart';
import '../overlay/klp_tooltip.dart';
import '../theme/klp_theme.dart';

/// 視窗控制按鈕樣式。
enum KlpWindowControlsStyle {
  /// 自動依據執行平台判斷。
  adaptive,

  /// Windows / Linux 風格（最小化、最大化、關閉）。
  windows,

  /// macOS 風格（關閉、最小化、最大化）。
  macOS,
}

class KlpWindowControls extends StatelessWidget {
  const KlpWindowControls({
    super.key,
    required this.onMinimize,
    required this.onToggleMaximize,
    required this.onClose,
    this.isMaximized = false,
    this.style = KlpWindowControlsStyle.adaptive,
    this.minimizeKey,
    this.maximizeKey,
    this.closeKey,
  });

  final VoidCallback? onMinimize;
  final VoidCallback? onToggleMaximize;
  final VoidCallback? onClose;
  final bool isMaximized;
  final KlpWindowControlsStyle style;
  final Key? minimizeKey;
  final Key? maximizeKey;
  final Key? closeKey;

  @override
  Widget build(BuildContext context) {
    final l10n = KlpLocalizations.of(context);
    final isMac =
        style == KlpWindowControlsStyle.macOS ||
        (style == KlpWindowControlsStyle.adaptive &&
            Theme.of(context).platform == TargetPlatform.macOS);

    final minimizeBtn = _WindowControlButton(
      key: minimizeKey,
      icon: KlpIcons.minus,
      label: l10n.windowMinimizeLabel,
      onPressed: onMinimize,
    );

    final maximizeBtn = _WindowControlButton(
      key: maximizeKey,
      icon: isMaximized ? KlpIcons.restore : KlpIcons.maximize,
      label: isMaximized ? l10n.windowRestoreLabel : l10n.windowMaximizeLabel,
      onPressed: onToggleMaximize,
    );

    final closeBtn = _WindowControlButton(
      key: closeKey,
      icon: KlpIcons.x,
      label: l10n.windowCloseLabel,
      onPressed: onClose,
      destructive: true,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: isMac
          ? [closeBtn, minimizeBtn, maximizeBtn]
          : [minimizeBtn, maximizeBtn, closeBtn],
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

    // 破壞性操作在啟用狀態使用完整語意底色，並切換成對比前景。
    final color = !enabled
        ? tokens.textFaint
        : widget.destructive && active
        ? tokens.onStatus
        : widget.destructive
        ? tokens.danger
        : tokens.textMuted;
    final backgroundColor = active
        ? widget.destructive
              ? tokens.danger
              : context.klp.selectionWash
        : tokens.clear;

    final button = Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(context.klp.shape.control),
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: SizedBox.square(
          dimension: context.klp.geometry.layout.windowHeaderControlSize,
          child: Center(
            child: KlpIcon(
              widget.icon,
              size: context.klp.geometry.layout.windowAppIconSize,
              color: color,
            ),
          ),
        ),
      ),
    );

    return KlpTooltip(
      message: widget.label,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: widget.label,
        child: button,
      ),
    );
  }
}
