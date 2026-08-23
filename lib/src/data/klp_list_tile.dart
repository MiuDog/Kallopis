import 'package:flutter/material.dart';

import '../feedback/klp_feedback_tone.dart';
import '../foundation/klp_icon.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpListTile extends StatefulWidget {
  const KlpListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.badge,
    this.selected = false,
    this.onPressed,
    this.titleColor,
    this.subtitleColor,
    this.compact = false,
    this.tone,
  });

  final String title;
  final String? subtitle;
  final String? icon;
  final Widget? trailing;
  final String? badge;
  final bool selected;
  final VoidCallback? onPressed;
  final Color? titleColor;
  final Color? subtitleColor;
  final bool compact;
  final KlpFeedbackTone? tone;

  @override
  State<KlpListTile> createState() => _KlpListTileState();
}

class _KlpListTileState extends State<KlpListTile> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    Color? statusColor;
    if (widget.tone != null && widget.tone != KlpFeedbackTone.neutral) {
      statusColor = switch (widget.tone!) {
        KlpFeedbackTone.warning => tokens.warning,
        KlpFeedbackTone.info => tokens.info,
        KlpFeedbackTone.success => tokens.success,
        KlpFeedbackTone.danger => tokens.danger,
        KlpFeedbackTone.neutral => null,
      };
    }

    final baseTileColor = statusColor != null
        ? statusColor.withValues(
            alpha: widget.selected
                ? context.klp.surface.listStatusSelectedOpacity
                : context.klp.surface.listStatusOpacity,
          )
        : (widget.selected ? tokens.selectionBackground : tokens.clear);
    final tileColor = _hovered || _focused
        ? Color.alphaBlend(context.klp.selectionWash, baseTileColor)
        : baseTileColor;

    final tile = Material(
      color: tileColor,
      borderRadius: BorderRadius.circular(context.klp.shape.control),
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        overlayColor: WidgetStatePropertyAll(tokens.clear),
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
                        role: widget.compact
                            ? KlpTextRole.sub
                            : KlpTextRole.body,
                        tone: widget.selected
                            ? KlpTextTone.primary
                            : KlpTextTone.muted,
                      ),
                      if (widget.subtitle != null) ...[
                        SizedBox(height: context.klp.space.tight),
                        KlpText(
                          widget.subtitle!,
                          role: KlpTextRole.caption,
                          tone: widget.selected
                              ? KlpTextTone.muted
                              : KlpTextTone.faint,
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.trailing != null) widget.trailing!,
              ],
            ),
          ),
        ),
      ),
    );

    return Semantics(
      button: widget.onPressed != null,
      // 沒有 onPressed 時本來就不是「可互動但目前停用」，而是壓根不回應互動，
      // 依 Semantics.enabled 的說明這種情況不該回報 enabled 狀態，所以給 null
      // 而不是 false。
      enabled: widget.onPressed != null ? true : null,
      selected: widget.selected,
      child: tile,
    );
  }
}
