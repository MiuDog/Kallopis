import 'package:flutter/material.dart';

import '../foundation/pln_icon.dart';
import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnListTile extends StatefulWidget {
  const PlnListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.selected = false,
    this.onPressed,
    this.titleColor,
    this.subtitleColor,
    this.compact = false,
  });

  final String title;
  final String? subtitle;
  final String? icon;
  final Widget? trailing;
  final bool selected;
  final VoidCallback? onPressed;
  final Color? titleColor;
  final Color? subtitleColor;
  final bool compact;

  @override
  State<PlnListTile> createState() => _PlnListTileState();
}

class _PlnListTileState extends State<PlnListTile> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final tile = Material(
      color: widget.selected
          ? tokens.selectionBackground
          : _hovered || _focused
          ? tokens.hoverSurface
          : tokens.hoverSurface.withValues(alpha: 0),
      borderRadius: BorderRadius.circular(PlnRadius.control),
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        overlayColor: const WidgetStatePropertyAll(Color(0x00000000)),
        borderRadius: BorderRadius.circular(PlnRadius.control),
        child: SizedBox(
          height: widget.compact ? PlnSize.controlSmall : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? PlnSpace.xs : PlnSpace.sm,
              vertical: widget.compact ? 0 : PlnSpace.sm,
            ),
            child: Row(
              children: [
                if (widget.icon != null) ...[
                  PlnIcon(
                    widget.icon!,
                    size: PlnSize.iconSmall,
                    color: widget.selected
                        ? tokens.selectionForeground
                        : _hovered
                        ? tokens.text
                        : tokens.textMuted,
                  ),
                  SizedBox(width: widget.compact ? PlnSpace.xs : PlnSpace.sm),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PlnText(
                        widget.title,
                        role: PlnTextRole.body,
                        color: widget.selected
                            ? tokens.selectionForeground
                            : _hovered || _focused
                            ? tokens.text
                            : widget.titleColor ?? tokens.textMuted,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.subtitle != null && !widget.compact)
                        PlnText(
                          widget.subtitle!,
                          role: PlnTextRole.caption,
                          tone: PlnTextTone.faint,
                          color: widget.selected
                              ? tokens.selectionForeground
                              : widget.subtitleColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                widget.trailing ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );

    return tile;
  }
}
