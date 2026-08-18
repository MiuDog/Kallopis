import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import '../foundation/klp_palette.dart';

class KlpListTile extends StatefulWidget {
  const KlpListTile({
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
  State<KlpListTile> createState() => _KlpListTileState();
}

class _KlpListTileState extends State<KlpListTile> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final tile = Material(
      color: widget.selected
          ? tokens.selectionBackground
          : _hovered || _focused
          ? context.klp.hoverSurface
          : context.klp.hoverSurface.withValues(alpha: 0),
      borderRadius: BorderRadius.circular(context.klp.shape.control),
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        overlayColor: const WidgetStatePropertyAll(KlpPalette.transparent),
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: SizedBox(
          height: widget.compact ? context.klp.space.controlHeightSmall : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact
                  ? context.klp.space.tight
                  : context.klp.space.compact,
              vertical: widget.compact ? 0 : context.klp.space.compact,
            ),
            child: Row(
              children: [
                if (widget.icon != null) ...[
                  KlpIcon(
                    widget.icon!,
                    size: context.klp.space.iconSmall,
                    color: widget.selected
                        ? tokens.selectionForeground
                        : _hovered
                        ? tokens.text
                        : tokens.textMuted,
                  ),
                  SizedBox(
                    width: widget.compact
                        ? context.klp.space.tight
                        : context.klp.space.compact,
                  ),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KlpText(
                        widget.title,
                        role: KlpTextRole.body,
                        color: widget.selected
                            ? tokens.selectionForeground
                            : _hovered || _focused
                            ? tokens.text
                            : widget.titleColor ?? tokens.textMuted,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.subtitle != null && !widget.compact)
                        KlpText(
                          widget.subtitle!,
                          role: KlpTextRole.caption,
                          tone: KlpTextTone.faint,
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
